# File: Assembler.py
# Author: Joseph Quismorio
# Date: 11/04/2021
# Section: 504
# E-mail: jfquismorio@tamu.edu 
# Description: Hack language assembler written in Python

import sys, string, re

#parser element is integrated within the assembler.

class Code(object): #holds codes of all mnemonics
  def dest(self, m):
    dest = { #all hack binary representations of dest mnemonics
      'M': '001',
      'D': '010',
      'MD': '011',
      'A': '100',
      'AM': '101',
      'AD': '110',
      'AMD': '111'
    }
    return dest.get(m, '000') #get the binary representation of dest mnemonic - if none, default to 000

  def comp(self, m):
    lead_bit = '0' #a or m bit representation
    if 'M' in m: 
        lead_bit = '1' #m is represented by 1, whereas a is represented by 0
        m = m.replace('M', 'A')
    comp = { #all hack binary representations of comp mnemonics
    '0': '101010',
    '1': '111111',
    '-1': '111010',
    'D': '001100',
    'A': '110000',
    '!D': '001101',
    '!A': '110001',
    '-D': '001111',
    '-A': '110011',
    'D+1': '011111',
    'A+1': '110111',
    'D-1': '001110',
    'A-1': '110010',
    'D+A': '000010',
    'D-A': '010011',
    'A-D': '000111',
    'D&A': '000000',
    'D|A': '010101',
    }
    comp_bits = comp.get(m, '000') #get the binary representation of comp mnemonic - if none, default to 000
    return lead_bit + comp_bits #return the 7-bit comp representation

  def jump(self, m):
      jump = { #all hack binary representations of jump mnemonics
      'JGT': '001',
      'JEQ': '010',
      'JGE': '011',
      'JLT': '100',
      'JNE': '101',
      'JLE': '110',
      'JMP': '111',
      }
      return jump.get(m, '000') #return binary representation of jump mnemonic - if none, default to 000

class Symbols(object): #special class that holds symbols
  def __init__(self):
    self.symbols = self.symbols()
    self.ram = 16

  def symbols(self): #table with special symbols binary representation
      symbols = {
      'SP': '000000000000000',
      'LCL': '000000000000001',
      'ARG': '000000000000010',
      'THIS': '000000000000011',
      'THAT': '000000000000100',
      'R0': '000000000000000',
      'R1': '000000000000001',
      'R2': '000000000000010',
      'R3': '000000000000011',
      'R4': '000000000000100',
      'R5': '000000000000101',
      'R6': '000000000000110',
      'R7': '000000000000111',
      'R8': '000000000001000',
      'R9': '000000000001001',
      'R10': '000000000001010',
      'R11': '000000000001011',
      'R12': '000000000001100',
      'R13': '000000000001101',
      'R14': '000000000001110',
      'R15': '000000000001111',
      'SCREEN': '100000000000000',
      'KBD': '110000000000000',
      }
      return symbols
  
  def has(self, symbol): #sees if symbol exists already
    return symbol in self.symbols

  def get(self, symbol): #if it does exist, get the address for the symbol
    return self.symbols[symbol]
  
  def add_to_symbols(self, symbol, address): #otherwise, add it to symbol list
    self.symbols[symbol] = address

class Assemble(object):
  def __init__(self, code, symbols): #initialize assembler
    self.code = code
    self.symbols = symbols
  
  def assemble(self, file): #assemble!
    asm_commands = [] #holds all commands from asm file
    hack_lines = [] #holds translated lines for writing later

    asm = open(file, 'r') #open the file from command line arg
    for asm_line in asm: #remove all comments
      new_line=re.sub(r'\/+.*\n|\n| *','',asm_line)
      if new_line!='':
        asm_commands.append(new_line) #append to asm commands
    asm.close() #close file
    
    line_number = 0
    for i in range(0, len(asm_commands)):
      if (asm_commands[i][0] == '('): #if L command - so it can loop back
        if not self.symbols.has(asm_commands[i][1:-1]):
          address = '{0:b}'.format(line_number) #make a new address for it from not already existent memory address
          base = (15 - len(address)) * '0' #remove length of line number address from 15 and make the rest zeros
          self.symbols.add_to_symbols(asm_commands[i][1:-1], (base + address)) #add new address and symbol to list
          line_number -= 1 #decrement
      line_number += 1 #otherwise, increment

    ram = 16 #setting aside extra space 
    for i in range(0, len(asm_commands)):
      symbol=re.findall(r'@[a-zA-Z]+.*', asm_commands[i]) #if is A command but contains text
      if symbol!=[]:
        if not self.symbols.has(symbol[0][1:]):
          address = '{0:b}'.format(ram) #make a new address for it from not already existent memory address
          base = (15 - len(address)) * '0' #remove length of ram address from 15 and make the rest zeros
          self.symbols.add_to_symbols(symbol[0][1:], (base + address)) #add new address and symbol to list
          ram += 1 #increment so we don't overwrite memory

    for i in range(0, len(asm_commands)):
      hack_line = '' #start off with empty line
      if(asm_commands[i][0] == '@'): #for A instruction
        hack_line += '0' #A instructions start with 0
        symbol = asm_commands[i][1:] #the rest following the @ is the symbol we look for
        try:
          int(symbol) #check if the symbol is an int 
        except ValueError: #if not, make an exception for valueerror
          if self.symbols.has(symbol): #if it doesn't already exist...
            hack_line += self.symbols.get(symbol) #otherwise you can just find the symbol in the list and add it to the line
            hack_lines.append(hack_line) #append to the list of hack commands
        else:
          address = '{0:b}'.format(int(symbol)) #if it is an int, same process except with the real int symbol
          base = (15 - len(address)) * '0' #remove length of ram address from 15 and make the rest zeros
          hack_line += (base + address) #append address to hack line
          hack_lines.append(hack_line) #append to the list of hack commands
    
      elif (asm_commands[i][0] != '('): #for C commands - barring L commands from being written
        hack_line += '111' #C commands start with 111
        dest = None #initialize dest, comp and jump
        comp = None
        jump = None
        c = asm_commands[i].split(';') #separate by semicolon in case of jump
        address = c[0] #address to jump to
        if len(c) == 2: #length of c must be 2
            jump = c[1] #the jump type will be held in the second part of the statement
        ### in case of C instruction ###
        c = address.split('=') #separate by the equals 
        if len(c) == 2: #length of c must be 2
            dest = c[0] #destination is held first
            comp = c[1] #comp is held last
        ### in case of no semicolon or equals ###
        else:
            comp = c[0] #comp is nothing
        hack_line += self.code.comp(comp) #add comp to line
        hack_line += self.code.dest(dest) #then dest
        hack_line += self.code.jump(jump) #then finally jump
        hack_lines.append(hack_line) #append to the list of hack commands

    hackfile = file.replace('.asm', '.hack') #create the hack file
    with open(hackfile, 'w') as f: 
      for line in hack_lines: #write each element of the hack command list to hack file
        f.write(line + "\n")
      f.close() #close file
      
filename = sys.argv[1] #take in argument from command line in shell
assembler = Assemble(Code(), Symbols())
assembler.assemble(filename) 
