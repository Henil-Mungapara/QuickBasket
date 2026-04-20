import os

file_path = r'e:\Flutter_Projects\smartattend\lib\Faculty_Dashboard\Generate_QrScreen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

target = """        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }"""
replacement = """        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
        if (_remainingSeconds == 0) {
          _qrData = null;
          timer.cancel();
        }"""

if target in content.replace("\r\n", "\n"):
    print("Found! Replacing...")
    # Normalize reading first
    content = content.replace("\r\n", "\n")
    content = content.replace(target, replacement)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        print("Success!")
else:
    print("Target not found. Let's dump out what's there:")
    # print context around the area
    idx = content.find("_remainingSeconds > 0")
    if idx != -1:
        print(content[idx-50:idx+150])
