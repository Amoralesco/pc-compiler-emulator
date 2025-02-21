import tkinter as tk
from tkinter import scrolledtext
import threading
import queue
import subprocess
from gincami import gincami32  # Asegúrate de que gincami.py esté en el mismo directorio
import os

class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Simulador Gincami32")
        self.input_queue = queue.Queue()

        # Consola principal
        display_frame = tk.Frame(root)
        display_frame.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
        console_frame = tk.Frame(display_frame)
        console_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.output_text = scrolledtext.ScrolledText(console_frame, width=80, height=20, state=tk.DISABLED)
        self.output_text.pack(fill=tk.BOTH, expand=True)
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

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

    def _append(self, message):
        self.output_text.configure(state=tk.NORMAL)
        self.output_text.insert(tk.END, str(message) + "\n")
        self.output_text.see(tk.END)
        self.output_text.configure(state=tk.DISABLED)

    def send_command(self, event=None):
        cmd = self.input_entry.get().strip()
        if cmd:
            self.write(f"> {cmd}")
            self.input_queue.put(cmd)
            self.input_entry.delete(0, tk.END)

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

def run_terminal_command_assembly():
    code_content = code_editor1.get("1.0", tk.END)
    proc = subprocess.run(
        ['./emsamblador'],
        input=code_content.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    result = proc.stdout.decode() + proc.stderr.decode()
    with open("relocate.txt", "w") as f:
        f.write(result)
    code_editor2.delete("1.0", tk.END)
    code_editor2.insert(tk.END, result)

def run_terminal_command_relocate():
    proc = subprocess.run(
        './enlazador < relocate.txt', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    result = proc.stdout.decode() + proc.stderr.decode()
    with open("binary.txt", "w") as f:
        f.write(result)
    code_editor3.delete("1.0", tk.END)
    code_editor3.insert(tk.END, result)

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

    # Panel izquierdo para el ensamblador
    panel1 = tk.Frame(command_frame)
    panel1.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel1, text="Ensamblador").pack(anchor="w")
    code_editor1 = scrolledtext.ScrolledText(panel1, wrap=tk.NONE, height=10)
    code_editor1.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel1, text="Ensamblar", command=run_terminal_command_assembly).pack(pady=5)

    # Panel central para relocate.txt
    panel2 = tk.Frame(command_frame)
    panel2.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel2, text="Enlazador cargador").pack(anchor="w")
    code_editor2 = scrolledtext.ScrolledText(panel2, wrap=tk.NONE, height=10)
    code_editor2.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel2, text="Enlazar & cargar", command=run_terminal_command_relocate).pack(pady=5)

    # Panel derecho para binary.txt
    panel3 = tk.Frame(command_frame)
    panel3.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5)
    tk.Label(panel3, text="Código binario").pack(anchor="w")
    code_editor3 = scrolledtext.ScrolledText(panel3, wrap=tk.NONE, height=10)
    code_editor3.pack(fill=tk.BOTH, expand=True)
    tk.Button(panel3, text="Ejecutar", command=run_terminal_command_binary).pack(pady=5)

    root.mainloop()
