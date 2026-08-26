# Intel 8086 Emulator


Uma implementação em Swift do processador Intel 8086, focada na emulação da arquitetura de 16 bits, manipulação de registradores, endereçamento de memória segmentada e execução de instruções.

---

## Visão Geral

O projeto oferece um modelo estruturado e modular da arquitetura x86 original de 16 bits. Desenvolvido utilizando o Swift Package Manager (SPM), o emulador abstrai os componentes vitais da CPU em módulos coesos e testáveis.


<img width="600" height="400" alt="Intel_C8086" src="https://github.com/user-attachments/assets/9b83c644-cb3b-4c0b-8ced-a3b375957da7" />


## Arquitetura e Componentes

- **Registradores de 16 bits (`Register16`)**: Abstração com acesso direto e síncrono às metades superior (`high`) e inferior (`low`) de 8 bits.
- **Gerenciamento de Memória (`Memory`)**: Emulação do mapa de memória de 1 MB (1.048.576 bytes) com suporte ao padrão Little-Endian para leitura e escrita de palavras (`readWord` e `writeWord`).
- **Endereçamento Físico (`Intel8086`)**: Cálculo de endereçamento segmentado real de 20 bits derivado do registrador de segmento de código e ponteiro de instrução (`CS << 4 + IP`).
- **Registradores e Flags**: Estruturação dos registradores de propósito geral, de segmento e sinalizadores de estado do processador.

## Requisitos

- Swift 5.9 ou superior
- macOS 13+ ou Linux com Swift Toolchain instalado

## Compilação e Testes

O projeto utiliza o Swift Package Manager nativo.

### Compilação do Módulo

Para compilar a biblioteca:

```bash
swift build
```

### Execução dos Testes

Para rodar a suíte de testes automatizados:

```bash
swift test
```

## Exemplo de Uso

```swift
import Intel8086

// Inicialização do emulador e memória
var cpu = Intel8086()
var memory = Memory()

// Leitura do endereço físico atual em modo real (CS:IP)
let physicalAddress = cpu.physicalAddress

// Leitura e escrita de palavras de 16 bits na memória
memory.writeWord(0x1234, at: 0x0000)
let value = memory.readWord(at: 0x0000) // Retorna 0x1234
```

## Estrutura do Projeto

```text
Intel8086/
├── Package.swift
├── Sources/
│   └── Intel8086/
│       ├── Intel8086.swift
│       ├── Memory.swift
│       ├── Register16.swift
│       ├── Registers.swift
│       └── Flags.swift
└── Tests/
    └── Intel8086Tests/
        ├── Intel8086Tests.swift
        ├── MemoryTests.swift
        ├── Register16Tests.swift
        └── RegistersTests.swift
```

## Licença

Este projeto é disponibilizado sob a licença MIT.
