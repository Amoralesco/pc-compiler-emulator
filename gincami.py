"""
Andres Felipe Morales Cortes
"""


class ALU:
    def __init__(self, psw):
        self.psw = psw

    def update_flags(self, result):
        self.psw['Z'] = int(result == 0)
        self.psw['N'] = int(result < 0)
        self.psw['C'] = int(result > 0xFFFFFFFF)

        if self.psw['C'] == 1:
            raise Exception("Stack overflow")

    def add(self, op1, op2):
        result = op1 + op2
        self.update_flags(result)
        return result

    def sub(self, op1, op2):
        result = op1 - op2
        self.update_flags(result)
        return result

    def mul(self, op1, op2):
        result = op1 * op2
        self.update_flags(result)
        return result

    def div(self, op1, op2):
        result = op1 // op2
        self.update_flags(result)
        return result

    def and_(self, op1, op2):
        result = op1 & op2
        self.update_flags(result)
        return result

    def or_(self, op1, op2):
        result = op1 | op2
        self.update_flags(result)
        return result

    def xor(self, op1, op2):
        result = op1 ^ op2
        self.update_flags(result)
        return result

    def not_(self, op1):
        result = ~op1
        self.update_flags(result)
        return result

    def shl(self, op1):
        result = op1 << 1
        self.update_flags(result)
        return result

    def shr(self, op1):
        result = op1 >> 1
        self.update_flags(result)
        return result

    def neg(self, op1):
        result = -op1
        self.update_flags(result)
        return result


class IOperipherals:
    def __init__(self):
        pass

    def read(self, message):
        return input(message)

    def write(self, message):
        print(message)


class Rinux:
    def __init__(self, hardware):
        self.hardware = hardware
        self.hardware.os = self
        self.pagging = 64  # tamaño de la página
        self.memory = len(self.hardware.memory)  # tamaño de la memoria
        self.memory_page = [0] * (self.memory // self.pagging)
        self.memory_page[-1] = 1

    def locate(self):  # establecer la dirección de memoria según la paginación
        for i in range(len(self.memory_page)):
            if self.memory_page[i] == 0:
                self.memory_page[i] = 1
                return i * self.pagging  # retorna la dirección de memoria física
        return -1  # si no hay memoria disponible

    def run(self, file):
        dir = self.locate()
        if dir >= 0:
            self.loadData(file, dir)
            self.hardware.run(dir)
            self.memory_page[dir // self.pagging] = 0
        else:
            self.write("No hay memoria disponible")

    def loadData(self, file, dir):  # leer el archivo y cargar el programa en la memoria línea por línea
        with open(file, 'r') as f:
            program = [
                int(line.strip(), 2)
                for line in f.readlines()
                if not line.strip().startswith("#") and line.strip() != ""
            ]
        for i, word in enumerate(program):
            self.hardware.memory[dir + i] = word

    def read(self, data):  # leer de un periférico
        return self.hardware.peripherals.read(data)

    def write(self, data):  # escribir en un periférico
        self.hardware.peripherals.write(data)

    def loop(self):
        self.write("Rinux started, Enter a command")
        self.status = True
        while self.status:
            try:
                command = self.read("#: ")
                if command.startswith("run"):
                    code = command.split(" ")[1]
                    self.run(code)
                elif command == "exit":
                    break
                elif command == "shom":
                    self.hardware.print_memory_in_binary(0, 64)
                elif command == "shor":
                    self.hardware.print_registers()
                else:
                    self.write("Unknown command")
            except Exception as e:
                self.write(f"Error: {str(e)}")

        self.write("Rinux stopped")

    def print_memory_in_binary(self, start, end):
        for i in range(start, end):
            print(f"{i:03d}: {self.hardware.memory[i]:032b}")

    def print_registers(self):
        for i in range(8):
            print(f"R{i}: {self.hardware.registers[i]:032b}")
        print(f"PC: {self.hardware.pc:032b}")
        print(f"SP: {self.hardware.sp:032b}")
        print(f"CIR: {self.hardware.cir:032b}")
        print(f"MAR: {self.hardware.mar:032b}")
        print(f"MDR: {self.hardware.mdr:032b}")
        print(f"PSW: {self.hardware.psw}")
        print(f"Clock cycle: {self.hardware.clock_cycle}")

    def return_memory_in_binary(self, start, end):
        memory = []
        for i in range(start, end):
            memory.append(f"{i:03d}: {self.hardware.memory[i]:032b}")
        return memory

    def return_registers(self):
        registers = []
        for i in range(8):
            registers.append(f"R{i}: {self.hardware.registers[i]:032b}")
        registers.append(f"PC: {self.hardware.pc:032b}")
        registers.append(f"SP: {self.hardware.sp:032b}")
        registers.append(f"CIR: {self.hardware.cir:032b}")
        registers.append(f"MAR: {self.hardware.mar:032b}")
        registers.append(f"MDR: {self.hardware.mdr:032b}")
        registers.append(f"PSW: {self.hardware.psw}")
        registers.append(f"Clock cycle: {self.hardware.clock_cycle}")
        return registers


class gincami32:
    def __init__(self):
        # memoria
        self.memory = [0] * (2 * 1024)  # Memoria simulada de 2KB

        # control unit
        self.clock_cycle = 0  # Reloj
        self.pc = 0  # Contador de Programa (PC)
        self.sp = 0  # Puntero de pila (SP)
        self.cir = 0  # Registro de instruccion actual (CIR)
        self.decode_unit = None  # Unidad de decodificacion
        self.psw = {'Z': 0, 'N': 0, 'C': 0}  # Registro de estado del programa (PSW)

        # registers
        self.registers = [0] * 8  # Registros R0-R7
        self.mar = 0  # Registro de direccion de memoria (MAR)
        self.mdr = 0  # Registro de datos de memoria (MDR)

        # ALU
        self.alu = ALU(self.psw)

        # peripherals
        self.peripherals = IOperipherals()

        self.os = Rinux(self)
        self.intruccion = {'opcode': 0, 'rd': 0, 'rs': 0, 'rt': 0, 'imm': 0, 'target': 0, 'mem_addr': 0}
        self.status = False  # define si el ciclo de reloj sigue corriendo

    def fetch(self):
        self.mar = self.pc  # MAR = PC
        self.mdr = self.memory[self.mar]  # MDR = Memoria[MAR]
        self.pc += 1  # PC = PC + 1
        self.cir = self.mdr  # CIR = MDR

    def decode(self):
        opcode = (self.cir >> 27) & 0x1F
        # LDI
        if opcode == 0b00000:
            self.intruccion = {'opcode': opcode, 'rd': self.cir & 0x07, 'imm': (self.cir >> 3) & 0xFFFFFF}
            return  # LOAD STORE
        if opcode in {0b00001, 0b00010}:
            self.intruccion = {'opcode': opcode, 'rd': self.cir & 0x07, 'mem_addr': (self.cir >> 3) & 0x07FF}
            return  # JMP JZ JP JNP JC CALL
        if opcode in {0b00011, 0b00100, 0b00101, 0b00110, 0b00111, 0b01001}:
            self.intruccion = {'opcode': opcode, 'target': self.cir & 0x07FF}
            return  # RET
        if opcode == 0b01000:
            self.intruccion = {'opcode': opcode}
            return  # ADD SUB MUL DIV AND OR XOR
        if opcode in {0b01010, 0b01011, 0b01100, 0b01101, 0b01110, 0b01111, 0b10000}:
            self.intruccion = {'opcode': opcode, 'rd': self.cir & 0x07, 'rs': (self.cir >> 3) & 0x07,
                               'rt': (self.cir >> 6) & 0x07}
            return  # MOV CMP
        if opcode in {0b10001, 0b10010}:
            self.intruccion = {'opcode': opcode, 'rd': self.cir & 0x07, 'rs': (self.cir >> 3) & 0x07}
            return  # PUSH POP READ WRITE CLR DEC INC NOT SHL SHR NEG
        if opcode in {0b10011, 0b10100, 0b10101, 0b10110, 0b10111, 0b11000, 0b11001, 0b11010, 0b11101, 0b11011, 0b11100,
                      0b11101}:
            self.intruccion = {'opcode': opcode, 'rd': self.cir & 0x07}
            return  # HALT NOP
        if opcode in (0b11110, 0b11111):
            self.intruccion = {'opcode': opcode}
            return  # no se reconoce la instrucción
        else:
            self.peripherals.write(f"Unknown opcode: {opcode:05b}")

    def execute(self):
        opcode = self.intruccion.get('opcode')
        rd = self.intruccion.get('rd')
        rs = self.intruccion.get('rs')
        rt = self.intruccion.get('rt')
        imm = self.intruccion.get('imm')
        target = self.intruccion.get('target')
        mem_addr = self.intruccion.get('mem_addr')

        if opcode == 0b00000:  # LDI
            self.registers[rd] = imm
            return
        if opcode == 0b00001:  # LOAD
            self.mar = mem_addr
            self.mdr = self.memory[self.mar]
            self.registers[rd] = self.mdr
            return
        if opcode == 0b00010:  # STORE
            self.mar = mem_addr
            self.mdr = self.registers[rd]
            self.memory[self.mar] = self.mdr
            return
        if opcode == 0b00011:  # JMP
            self.pc = target
            return
        if opcode == 0b00100:  # JZ
            if self.psw['Z']:
                self.pc = target
            return
        if opcode == 0b00101:  # JP
            if not self.psw['N']:
                self.pc = target
            return
        if opcode == 0b00110:  # JNP
            if self.psw['N']:
                self.pc = target
            return
        if opcode == 0b00111:  # JC
            if self.psw['C']:
                self.pc = target
            return
        if opcode == 0b01000:  # RET
            self.mar = self.sp
            self.mdr = self.memory[self.mar]
            self.sp += 1
            self.pc = self.mdr
            return
        if opcode == 0b01001:  # CALL
            self.mar = self.sp
            self.mdr = self.pc
            self.memory[self.mar] = self.mdr
            self.sp -= 1
            self.pc = target
            return
        if opcode == 0b01010:  # ADD
            self.registers[rd] = self.alu.add(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b01011:  # SUB
            self.registers[rd] = self.alu.sub(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b01100:  # MUL
            self.registers[rd] = self.alu.mul(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b01101:  # DIV
            self.registers[rd] = self.alu.div(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b01110:  # AND
            self.registers[rd] = self.alu.and_(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b01111:  # OR
            self.registers[rd] = self.alu.or_(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b10000:  # XOR
            self.registers[rd] = self.alu.xor(self.registers[rt], self.registers[rs])
            return
        if opcode == 0b10001:  # MOV
            self.registers[rd] = self.registers[rs]
            return
        if opcode == 0b10010:  # CMP
            self.alu.sub(self.registers[rs], self.registers[rd])
            return
        if opcode == 0b10011:  # PUSH
            self.mdr = self.registers[rd]
            self.mar = self.sp
            self.memory[self.mar] = self.mdr
            self.sp -= 1
            return
        if opcode == 0b10100:  # POP
            self.mar = self.sp
            self.mdr = self.memory[self.mar]
            self.sp += 1
            self.registers[rd] = self.mdr
            return
        if opcode == 0b10101:  # READ
            self.registers[rd] = int(self.peripherals.read("Enter a number: "))
            return
        if opcode == 0b10110:  # WRITE
            self.peripherals.write(self.registers[rd])
            return
        if opcode == 0b10111:  # CLR
            self.registers[rd] = 0
            return
        if opcode == 0b11000:  # DEC
            self.registers[rd] -= 1
            return
        if opcode == 0b11001:  # INC
            self.registers[rd] += 1
            return
        if opcode == 0b11010:  # NOT
            self.registers[rd] = self.alu.not_(self.registers[rd])
            return
        if opcode == 0b11011:  # SHL
            self.registers[rd] = self.alu.shl(self.registers[rd])
            return
        if opcode == 0b11100:  # SHR
            self.registers[rd] = self.alu.shr(self.registers[rd])
            return
        if opcode == 0b11101:  # NEG
            self.registers[rd] = self.alu.neg(self.registers[rd])
            return
        if opcode == 0b11110:  # HALT
            self.status = False
            return
        if opcode == 0b11111:  # NOP
            return

        else:
            self.peripherals.write(f"Unknown opcode: {opcode:05b}")

    def run(self, dir):
        self.pc = dir
        self.status = True
        while self.status:
            self.fetch()
            self.decode()
            self.execute()
            self.clock_cycle += 1


if __name__ == "__main__":
    cpu = gincami32()
    cpu.os.loop()
