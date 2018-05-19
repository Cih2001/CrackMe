with open("../build/DosStub.exe", "r+b") as f:
    f.seek(4)
    f.write('\5')