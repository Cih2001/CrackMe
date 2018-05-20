import sys

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


rotr = lambda val, bits, size : ((val >> bits) & (2**size-1)) | ((val << (size - bits)) & (2**size-1))
rotl = lambda val, bits, size : ((val << bits) & (2**size-1)) | ((val >> (size - bits)) & (2**size-1))

parameters = {
    "header_fix" : lambda arg: header_fix(sys.argv[2]),
    "rot_string" : lambda arg: rot_string(sys.argv[2], sys.argv[3])
}

parameters[sys.argv[1]](sys.argv)