import sys
from rc4 import *

rotr = lambda val, bits, size : ((val >> bits) & (2**size-1)) | ((val << (size - bits)) & (2**size-1))
rotl = lambda val, bits, size : ((val << bits) & (2**size-1)) | ((val >> (size - bits)) & (2**size-1))

def rc4_region(path, key, start, length):
    with open(path, 'r+b') as f:
        f.seek(start)
        file_content = f.read(length)
        rc4 = Calc_RC4(key, file_content)
        return rc4

def header_fix(path):
    print "PYTHON: Fixing header for file: %s" % path
    with open(path, "r+b") as f:
        f.seek(4)
        f.write('\5')

def rot_string(path, str_source):
    print "PYTHON: Rotating string %s in file: %s" % (str_source, path)
    
    with open(path, 'r+b') as f:
        file_content = f.read()
        str_idx = file_content.find(str_source)
        
        output_buf = ""
        for i, c in enumerate(file_content):
            if i >= str_idx and i < str_idx + len(str_source):
                output_buf += chr(rotr(ord(c),4,8))
            else:
                output_buf += c
        
        f.seek(0)
        f.write(output_buf)

def test_rc4(path, start, length):
    print "PYTHON: Rc4 %x : %x in file: %s" % (start,length, path)
    key = "CrAc"
    rc4 = rc4_region(path, key, start, length)
    import sys
    for c in rc4:
        sys.stdout.write("%02X" % ord(c))
    print

parameters = {
    "header_fix"    : lambda arg: header_fix(sys.argv[2]),
    "rot_string"    : lambda arg: rot_string(sys.argv[2], sys.argv[3]),
    "test_rc4"      : lambda arg: test_rc4(sys.argv[2], int(sys.argv[3],16), int(sys.argv[4],16))
}

parameters[sys.argv[1]](sys.argv)