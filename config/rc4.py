def KSA(key):
    keylength = len(key)

    S = range(256)

    j = 0
    for i in range(256):
        j = (j + S[i] + key[i % keylength]) % 256
        S[i], S[j] = S[j], S[i]  # swap

    return S

def PRGA(S):
    i = 0
    j = 0
    while True:
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]  # swap

        K = S[(S[i] + S[j]) % 256]
        yield K


def RC4(key):
    S = KSA(key)
    return PRGA(S)

def Calc_RC4(key, plaintext):
    def convert_key(s):
        return [ord(c) for c in s]
    key = convert_key(key)

    keystream = RC4(key)

    result = ""
    for c in plaintext:
        result += chr(ord(c) ^ keystream.next())
    
    return result

if __name__ == '__main__':

    key = 'CrAc'
    plaintext = b'\xde\xad\xf0\x0d'
    # ciphertext should be 13e07c53

    rc4 = Calc_RC4(key, plaintext)
    import sys
    for c in rc4:
        sys.stdout.write("%02X" % ord(c))
    print 