# Intel 8086 Emulator


<img width="600" height="400" alt="Intel_C8086" src="https://github.com/user-attachments/assets/9b83c644-cb3b-4c0b-8ced-a3b375957da7" />


Um emulador do **Intel 8086** feito em Swift.

Esse projeto começou como uma forma de voltar a estudar arquitetura de computadores e entender, na prática, como um processador de 16 bits funciona por dentro.

A ideia é construir o emulador aos poucos, começando pelos fundamentos — registradores, memória, flags e ALU — e eventualmente chegar à execução das instruções do 8086.

Estou desenvolvendo tudo usando **TDD**, então cada parte nova começa pelos testes antes da implementação.

## Status

🚧 Em desenvolvimento

Atualmente já temos:

- [x] Registradores de 16 bits
- [x] Memória de 1 MB
- [x] Endereçamento segmentado
- [x] FLAGS
- [ ] ALU
- [ ] Instruções
- [ ] Stack
- [ ] Interrupções
- [ ] Ciclo de busca e execução
- [ ] ...
  
## Por que Swift?

Porque é a linguagem que uso profissionalmente e achei interessante usar uma linguagem moderna para implementar uma arquitetura de 1978.

Além disso, implementar algo tão baixo nível em uma linguagem como Swift é uma experiência interessante por si só.

## Objetivo

Mais do que criar um emulador completo, a ideia é **aprender**.

Quero entender o 8086 de baixo para cima, descobrir como cada parte funciona e registrar esse processo no código.

Não estou tentando simplesmente reproduzir um emulador existente. Quero construir cada componente entendendo o motivo de ele existir e como ele se comportava no hardware original.

## Desenvolvimento

O projeto utiliza **Swift Package Manager** e **XCTest**.

A implementação está sendo desenvolvida seguindo uma abordagem de **Test-Driven Development (TDD)**:

1. Criar o teste
2. Fazer o teste falhar
3. Implementar o comportamento
4. Fazer o teste passar
5. Refatorar quando necessário

Os testes também são executados automaticamente através do **GitHub Actions**.

## Arquitetura

A implementação está sendo construída de forma incremental.

A ideia é separar os principais componentes do processador:


```text
Intel8086
├── Registers
├── Flags
├── Memory
├── ALU
└── Instruction Execution

```
## Licença

Este projeto é disponibilizado sob a licença MIT.
