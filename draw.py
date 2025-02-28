import os
import platform
import queue
import subprocess
import threading
import tkinter as tk
from tkinter import scrolledtext

from gincami import gincami32  # Asegúrate de que gincami.py esté en el mismo directorio


class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Simulador Gincami32")
        self.input_queue = queue.Queue()

        self.displayed_memory = None
        self.displayed_registers = None

        # Consola principal
        display_frame = tk.Frame(root)
        display_frame.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

        display_frame.columnconfigure(0, weight=1)
        display_frame.columnconfigure(1, weight=1)
        display_frame.columnconfigure(2, weight=1)

        console_frame = tk.Frame(display_frame)
        console_frame.grid(row=0, column=0, sticky="nsew", padx=5, pady=5)
        tk.Label(console_frame, text="Consola").pack(anchor="n", pady=5)
        self.output_text = scrolledtext.ScrolledText(console_frame, width=60, height=20, state=tk.DISABLED)
        self.output_text.pack(fill=tk.BOTH, expand=True)
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

        memory_frame = tk.Frame(display_frame)
        memory_frame.grid(row=0, column=1, sticky="nsew", padx=5, pady=5)
        tk.Label(memory_frame, text="Memoria").pack(anchor="n", pady=5)
        self.memory_display = scrolledtext.ScrolledText(memory_frame, width=60, height=20)
        self.memory_display.pack()

        register_frame = tk.Frame(display_frame)
        register_frame.grid(row=0, column=2, sticky="nsew", padx=5, pady=5)
        tk.Label(register_frame, text="Registros").pack(anchor="n", pady=5)
        self.register_display = scrolledtext.ScrolledText(register_frame, width=60, height=20)
        self.register_display.pack()

        # Entrada y botón de comando para la CPU
        input_frame = tk.Frame(root)
        input_frame.pack(padx=10, pady=5, fill=tk.X)
        tk.Label(input_frame, text="Comando CPU:").pack(side=tk.LEFT)
        self.input_entry = tk.Entry(input_frame)
        self.input_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        self.input_entry.bind("<Return>", self.send_command)
        tk.Button(input_frame, text="Enviar", command=self.send_command).pack(side=tk.LEFT, padx=5)

        # Configuración de la CPU
        self.cpu = gincami32()
        self.cpu.peripherals = self
        self.cpu.os.hardware.peripherals = self

        self.os_thread = threading.Thread(target=self.cpu.os.loop, daemon=True)
        self.os_thread.start()
        self.max_console_lines = 1000

        self.update_memory_display()
        self.update_registers_display()

    def _append(self, message):
        self.output_text.configure(state=tk.NORMAL)
        # Limitar el número de líneas
        content = self.output_text.get("1.0", tk.END).splitlines()
        if len(content) > self.max_console_lines:
            self.output_text.delete("1.0", f"{len(content) - self.max_console_lines}.0")
        self.output_text.insert(tk.END, str(message) + "\n")
        self.output_text.see(tk.END)
        self.output_text.configure(state=tk.DISABLED)

    def read(self, prompt):
        self.write(prompt)
        self.root.update()  # Actualizar la interfaz antes de esperar input

        # Asegurarse que el foco esté en el campo de entrada
        self.input_entry.focus_set()

        while True:
            try:
                value = self.input_queue.get(timeout=0.1)
                return value
            except queue.Empty:
                self.root.update()

    def write(self, message):
        self.output_text.after(0, self._append, message)

    def send_command(self, event=None):
        cmd = self.input_entry.get().strip()
        if cmd:
            self.write(f"> {cmd}")
            self.input_queue.put(cmd)
            self.input_entry.delete(0, tk.END)
        self.update_memory_display()
        self.update_registers_display()

    def on_closing(self):
        print("Cerrando aplicación...")
        # Señalizar a los hilos que deben terminar
        self.cpu.status = False  # Detiene el ciclo principal de la CPU 
        # Limpiar la cola de entrada
        while not self.input_queue.empty():
            try:
                self.input_queue.get_nowait()
            except queue.Empty:
                break
        # Destruir la ventana principal
        self.root.destroy()
        # Forzar la terminación del proceso
        os._exit(0)

    def update_memory_display(self):
        memory = self.cpu.os.return_memory_in_binary(0, 64)
        if memory == self.displayed_memory:
            self.root.after(1000, self.update_memory_display)
            return
        self.displayed_memory = memory
        self.memory_display.delete("1.0", tk.END)
        for line in memory:
            self.memory_display.insert(tk.END, line + "\n")
        self.root.after(1000, self.update_memory_display)

    def update_registers_display(self):
        registers = self.cpu.os.hardware.os.return_registers()
        if registers == self.displayed_registers:
            self.root.after(1000, self.update_registers_display)
            return
        self.displayed_registers = registers
        self.register_display.delete("1.0", tk.END)
        for reg in registers:
            self.register_display.insert(tk.END, reg + "\n")
        self.root.after(1000, self.update_registers_display)


def run_terminal_command_preprocessor():
    os_name = platform.system()
    if os_name == "Windows":
        command = ['wsl', './preprocesador']
    else:
        command = ['./preprocesador']
    code_content = code_editor_preprocessor.get("1.0", tk.END)
    proc = subprocess.run(command, input=code_content.encode(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = proc.stdout.decode() + proc.stderr.decode()
    with open("preprocessed.txt", "w") as f:
        f.write(result)
    code_editor1.delete("1.0", tk.END)
    code_editor1.insert(tk.END, result)


def run_terminal_command_processor():
    os_name = platform.system()
    if os_name == "Windows":
        command = ['wsl', './procesador']
    else:
        command = ['./procesador']
    proc = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = proc.stdout.decode() + proc.stderr.decode()
    with open("processor_output.txt", "w") as f:
        f.write(result)
    code_editor_processor.delete("1.0", tk.END)
    code_editor_processor.insert(tk.END, result)


def run_terminal_command_assembly():
    os_name = platform.system()
    if os_name == "Windows":
        command = ['wsl', './emsamblador']
    else:
        command = ['./emsamblador']
    # Lee el contenido escrito en la pantalla (editor ensamblador)
    code_content = code_editor1.get("1.0", tk.END)
    # Ejecuta el comando ./emsablador pasándole el contenido como entrada estándar
    proc = subprocess.run(command, input=code_content.encode(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if os_name == "Windows":
        command2 = ['wsl', './soluter']
    else:
        command2 = ['./soluter']
    proc_s = subprocess.run(command2, input=proc.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = proc_s.stdout.decode() + proc_s.stderr.decode()
    with open("relocate.txt", "w") as f:
        f.write(result)
    code_editor2.delete("1.0", tk.END)
    code_editor2.insert(tk.END, result)


def run_terminal_command_relocate():
    proc = subprocess.run('./enlazador < relocate.txt', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = proc.stdout.decode() + proc.stderr.decode()
    with open("binary.txt", "w") as f:
        f.write(result)
    code_editor3.delete("1.0", tk.END)
    code_editor3.insert(tk.END, result)  # Se removió la actualización de la tabla de símbolos


def run_terminal_command_binary():
    try:
        # Limpiar la cola de entrada
        while not app.input_queue.empty():
            app.input_queue.get_nowait()
        # Colocar el comando run en la cola
        app.input_queue.put(f"run binary.txt")
    except Exception as e:
        app.write(f"Error: {str(e)}")


if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)

    # Panel que contiene los tres editores
    command_frame = tk.Frame(root)
    command_frame.pack(padx=10, pady=5, fill=tk.BOTH, expand=True)

    # Panel adicional para el preprocesador
    panel_preprocessor = tk.Frame(command_frame)
    panel_preprocessor.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel_preprocessor, text="Preprocesador").pack(anchor="w")
    code_editor_preprocessor = scrolledtext.ScrolledText(panel_preprocessor, wrap=tk.NONE, height=10, width=40)
    code_editor_preprocessor.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel_preprocessor, text="Preprocesar", command=run_terminal_command_preprocessor).pack(pady=5)

    panel_processor = tk.Frame(command_frame)
    panel_processor.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel_processor, text="Procesador").pack(anchor="w")
    code_editor_processor = scrolledtext.ScrolledText(panel_processor, wrap=tk.NONE, height=10, width=40)
    code_editor_processor.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel_processor, text="Procesar", command=run_terminal_command_processor).pack(pady=5)

    # Panel izquierdo para el ensamblador
    panel1 = tk.Frame(command_frame)
    panel1.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel1, text="Ensamblador").pack(anchor="w")
    code_editor1 = scrolledtext.ScrolledText(panel1, wrap=tk.NONE, height=10, width=40)
    code_editor1.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel1, text="Ensamblar", command=run_terminal_command_assembly).pack(pady=5)

    # Contenedor para el panel de relocate.txt (sin tabla de símbolos)
    container_panel2 = tk.Frame(command_frame)
    container_panel2.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    container_panel2.columnconfigure(0, weight=1, minsize=200)

    # Panel central para relocate.txt (Enlazador cargador)
    panel2 = tk.Frame(container_panel2)
    panel2.grid(row=0, column=0, sticky="nsew")
    tk.Label(panel2, text="Enlazador cargador").pack(anchor="w")
    code_editor2 = scrolledtext.ScrolledText(panel2, wrap=tk.NONE, height=10, width=40)
    code_editor2.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel2, text="Enlazar & cargar", command=run_terminal_command_relocate).pack(pady=5)

    # Panel derecho para binary.txt
    panel3 = tk.Frame(command_frame)
    panel3.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel3, text="Código binario").pack(anchor="w")
    code_editor3 = scrolledtext.ScrolledText(panel3, wrap=tk.NONE, height=10, width=40)
    code_editor3.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel3, text="Ejecutar", command=run_terminal_command_binary).pack(pady=5)

    root.mainloop()
