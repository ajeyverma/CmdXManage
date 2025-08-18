
# CmdXManage

CmdXManage is a **cross-platform tool** to manage and organize custom commands/aliases in:  
- 🖥️ Windows PowerShell  
- 💻 Windows CMD  
- 🐧 Linux & macOS (bash/zsh)  
- 📱 Termux (Android)

This tool allows developers, system administrators, and tech enthusiasts to:

- Quickly **add, edit, or remove custom commands**.
- **Organize frequently used commands** for faster workflow.
- Maintain **cross-platform command consistency**, so the same aliases or scripts can be used on different machines and operating systems.
- Easily **list all available commands** for reference at any time.

CmdXManage is perfect for anyone who works on multiple platforms and wants to **save time, reduce repetitive typing**, and **keep commands centralized**.

---
## ⚡ Key Advantages

- **Cross-Platform:** Works seamlessly on Windows, Linux, macOS, and Termux.  
- **User-Friendly:** Simple scripts with clear instructions for beginners.  
- **Flexible:** Supports both **manual download** and **Git-based installation**.  
- **Time-Saving:** Quickly manage aliases and commands without editing multiple shell configuration files.  
- **Open Source:** Fully free to use, modify, and share under the MIT License.

---
## 🖥️ Platform Support

| Platform                         | Script            | Status            | Git Installation Command / Method |
|----------------------------------|-------------------|------------------|-----------------------------------|
| 🖥️ Windows PowerShell            | `CmdXManage.ps1`  | ✅ Full Support  | `winget install --id Git.Git -e --source winget` |
| 💻 Windows CMD                   | `CmdXManage.bat`  | ✅ Full Support  | [Download Git for Windows](https://git-scm.com/download/win) |
| 🐧 Linux (Debian/Ubuntu)         | `CmdXManage.sh`   | ✅ Full Support  | `sudo apt install git -y` |
| 🐧 Linux (Fedora)                | `CmdXManage.sh`   | ✅ Full Support  | `sudo dnf install git -y` |
| 🐧 Linux (Arch)                  | `CmdXManage.sh`   | ✅ Full Support  | `sudo pacman -S git` |
| 🍎 macOS (zsh/bash)              | `CmdXManage.sh`   | ✅ Full Support  | `xcode-select --install` |
| 📱 Termux (Android)              | `CmdXManage.sh`   | ✅ Full Support  | `pkg install git -y` |

---

## 🚀 Installation & Usage

### Method 1: Using Git (Recommended)

#### 🖥️ Windows PowerShell
```powershell
# Install Git (if not installed)
winget install --id Git.Git -e --source winget

# Clone the repository
git clone https://github.com/ajeyverma/CmdXManage.git
cd CmdXManage

# Run the script
.\CmdXManage.ps1
````

---

#### 💻 Windows CMD

```cmd
:: Install Git (if not installed)
:: Download from https://git-scm.com/download/win

:: Clone the repository
git clone https://github.com/ajeyverma/CmdXManage.git
cd CmdXManage

:: Run the script
CmdXManage.bat
```

---

#### 🐧 Linux (bash/zsh)

```bash
# Install Git (if not installed)
sudo apt install git -y      # Debian/Ubuntu
# or
sudo dnf install git -y      # Fedora
# or
sudo pacman -S git           # Arch

# Clone the repository
git clone https://github.com/ajeyverma/CmdXManage.git
cd CmdXManage

# Give execute permission and run
chmod +x CmdXManage.sh
./CmdXManage.sh
```

---

#### 🍎 macOS (zsh/bash)

```bash
# Install Git (if not installed)
xcode-select --install

# Clone the repository
git clone https://github.com/ajeyverma/CmdXManage.git
cd CmdXManage

# Give execute permission and run
chmod +x CmdXManage.sh
./CmdXManage.sh
```

---

#### 📱 Termux (Android)

```bash
# Install Git
pkg install git -y

# Clone the repository
git clone https://github.com/ajeyverma/CmdXManage.git
cd CmdXManage

# Give execute permission and run
chmod +x CmdXManage.sh
./CmdXManage.sh
```

---
### Method 2: Manual Download (No Git Required)

#### Option 1: Download the Full Repository
1. Go to the [CmdXManage GitHub Repository](https://github.com/ajeyverma/CmdXManage).  
2. Click **Code → Download ZIP**.  
3. Extract the ZIP file to a folder of your choice.  
4. Navigate to the folder and run the script for your platform:

- **Windows PowerShell**
```powershell
cd <path>\CmdXManage
.\CmdXManage.ps1
```
- **Windows CMD**
```
cd <path>\CmdXManage
CmdXManage.bat
```
- **Linux / macOS / Termux**
```
cd <path>/CmdXManage
chmod +x CmdXManage.sh
./CmdXManage.sh
```
#### Option 2: Download Only Your Platform Script

You can also download the script file specific to your platform directly:

| Platform               | Script File      | Direct Download Link                                                        |
| ---------------------- | ---------------- | --------------------------------------------------------------------------- |
| Windows PowerShell     | `CmdXManage.ps1` | [Download](https://github.com/ajeyverma/CmdXManage/raw/main/CmdXManage.ps1) |
| Windows CMD            | `CmdXManage.bat` | [Download](https://github.com/ajeyverma/CmdXManage/raw/main/CmdXManage.bat) |
| Linux / macOS / Termux | `CmdXManage.sh`  | [Download](https://github.com/ajeyverma/CmdXManage/raw/main/CmdXManage.sh)  |


* After downloading, give execute permission (Linux/macOS/Termux) and run:
```
chmod +x CmdXManage.sh
./CmdXManage.sh
```
* For Windows PowerShell / CMD, just double-click or run in terminal.



---
## ✨ Features

* Add new custom commands
* Edit existing commands
* Remove commands
* List all available commands
* Works across **PowerShell, CMD, Linux/macOS, and Termux**

---

## 📜 License

[MIT](LICENSE) – free to use, modify, and share.

Copyright (c) 2025 Ajay Kumar <br> 
*(also known as Ajay Verma / Aarush Chaudhary)*


---

## 👨‍💻 Author

Developed and maintained by **Ajay Kumar**  
*(also known as **Ajay Verma** / **Aarush Chaudhary** in different communities)*  

- GitHub: [@ajeyverma](https://github.com/ajeyverma)  
- LinkedIn: [Ajay Verma](https://www.linkedin.com/in/ajeyverma/)  
- Instagram: [@ajayverma](https://instagram.com/ajayverma097)  

---

## 🤝 Contributing

Pull requests are welcome! <br>
For major changes, please open an issue first to discuss what you’d like to improve.


