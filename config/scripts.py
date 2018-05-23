import sys
import codecs
from rc4 import Calc_RC4


# rotr(0xab,4,8) = 0xba
# rotr(0xab,4,16) = 0x0xb00a
def rotr(val, bits, size): return ((val >> bits) & (
    2**size-1)) | ((val << (size - bits)) & (2**size-1))


def rotl(val, bits, size): return ((val << bits) & (
    2**size-1)) | ((val >> (size - bits)) & (2**size-1))


def cut0x(str): return str[2:] if str.startswith("0x", 0, 2) else str


def rc4_region(path, key, start, length):
    with open(path, 'r+b') as f:
        f.seek(start)
        file_content = f.read(length)
        rc4 = Calc_RC4(key, file_content)
        return rc4


def rc4_sig_to_sig(path, key0, key1, key2, sig0, sig1, sig2):
    print "PYTHON: Encrypting RC4 regions in file: %s" % path
    sig0, sig1, sig2 = cut0x(sig0), cut0x(sig1), cut0x(sig2)
    offset_sig0, offset_sig1, offset_sig2 = -1, -1, -1
    with open(path, 'r+b') as f:
        file_content = f.read()
        # find signatures:
        offset_sig0 = file_content.find(codecs.decode(sig0, "hex"))
        offset_sig1 = file_content.find(codecs.decode(sig1, "hex"))
        offset_sig2 = file_content.find(codecs.decode(sig2, "hex"))

        if offset_sig0 < 0 or offset_sig1 < 0 or offset_sig2 < 0:
            print "PYTHON: Could not find signatures :0x%X 0x%X 0x%X" % (
                offset_sig0, offset_sig1, offset_sig2)
            return
        print "PYTHON: Found signatures :0x%X 0x%X 0x%X" % (
            offset_sig0, offset_sig1, offset_sig2)
        import sys

        # Encrypt sig 0 to sig 1
        rc4 = Calc_RC4(key0, file_content[offset_sig0:offset_sig1])

        f.seek(offset_sig0)
        f.write(rc4)

        sys.stdout.write("Enc RC4 :0x%X 0x%X 0x%X: " %
                         (offset_sig0, offset_sig1, len(rc4)))
        for c in rc4:
            sys.stdout.write("%02X" % ord(c))
        print

        # Encrypt sig 1 to sig 2
        rc4 = Calc_RC4(key1, file_content[offset_sig0:offset_sig2])

        f.seek(offset_sig1)
        f.write(rc4[offset_sig1-offset_sig0:])

        sys.stdout.write("Enc RC4 :0x%X 0x%X 0x%X: " % (
            offset_sig1, offset_sig2, len(rc4[offset_sig1-offset_sig0:])))
        for c in rc4[offset_sig1-offset_sig0:]:
            sys.stdout.write("%02X" % ord(c))
        print

        # Encrypt sig 2
        rc4 = Calc_RC4(key2, file_content[offset_sig0:offset_sig2+4])

        f.seek(offset_sig2)
        f.write(rc4[offset_sig2-offset_sig0:])

        sys.stdout.write("Enc RC4 :0x%X 0x%X 0x%X: " % (
            offset_sig2, offset_sig2+4, len(rc4[offset_sig2-offset_sig0:])))
        for c in rc4[offset_sig2-offset_sig0:]:
            sys.stdout.write("%02X" % ord(c))
        print
    return


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
                output_buf += chr(rotr(ord(c), 4, 8))
            else:
                output_buf += c

        f.seek(0)
        f.write(output_buf)
    return


def xor_dos_part(path, key, offset_start, signature_end):
    print "PYTHON: XORing dos part in file: %s" % (path)
    signature_end = cut0x(signature_end)
    with open(path, 'r+b') as f:
        file_content = f.read()
        offset_sig = file_content.find(codecs.decode(signature_end, "hex"))
        if offset_sig < 0:
            print "PYTHON: cannot find signature for xor."
            return
        print "PYTHON: XORing %X : %X" % (offset_start, offset_sig)
        f.seek(offset_start)
        for c in file_content[offset_start:offset_sig]:
            f.write(chr(ord(c) ^ key))
    return


def test_rc4(path, start, length):
    print "PYTHON: Rc4 %x : %x in file: %s" % (start, length, path)
    key = "CrAc"
    rc4 = rc4_region(path, key, start, length)
    import sys
    for c in rc4:
        sys.stdout.write("%02X" % ord(c))
    print


parameters = {
    "header_fix": lambda arg: header_fix(arg[2]),
    "rot_string": lambda arg: rot_string(arg[2], arg[3]),
    "test_rc4": lambda arg: test_rc4(arg[2], int(arg[3], 16), int(arg[4], 16)),
    "rc4_region": lambda arg: rc4_sig_to_sig(arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8]),
    "xor_dos_part": lambda arg: xor_dos_part(arg[2], int(arg[3], 16), int(arg[4], 16), arg[5])
}

parameters[sys.argv[1]](sys.argv)
