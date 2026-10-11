# xcompose-ptbr-us-intl

Uma configuração `.XCompose` simples para usuários Linux que digitam em **português do Brasil** e **inglês** usando um teclado **US International**.

O objetivo é manter as regras padrão de Compose do sistema e corrigir apenas alguns comportamentos que são inconvenientes para quem alterna entre PT-BR e inglês.

## O que este projeto corrige

A regra principal é:

```text
' + c  →  ç
' + C  →  Ç
```

Ele também garante explicitamente os caracteres usados no português brasileiro moderno:

| Teclas | Resultado |
|---|---|
| `' + a/e/i/o/u` | á é í ó ú |
| `` ` + a `` | à |
| `^ + a/e/o` | â ê ô |
| `~ + a/o` | ã õ |
| `' + c` | ç |

As versões maiúsculas também estão incluídas.

## Apóstrofo amigável para digitação em inglês

Em algumas tabelas Compose do Linux, a tecla de apóstrofo configurada como `dead_acute` pode se combinar com consoantes e produzir caracteres que raramente são úteis para quem escreve em português e inglês.

Esta configuração faz com que essas combinações produzam um apóstrofo literal seguido da letra.

Exemplos:

```text
' + m  →  'm
' + s  →  's
' + t  →  't
' + n  →  'n
```

Isso torna natural a digitação de contrações comuns em inglês:

```text
I'm
it's
don't
we'll
John's
```

A exceção é a letra `c`, que propositalmente gera `ç`.

## Como funciona

O arquivo começa com:

```text
include "%L"
```

Isso mantém disponível a tabela Compose padrão do sistema.

O projeto sobrescreve apenas as combinações necessárias para melhorar a digitação em português do Brasil e inglês.

Essa abordagem mantém o arquivo menor, mais fácil de entender e mais simples de auditar do que substituir toda a tabela Compose.

## Estrutura do repositório

```text
xcompose-ptbr-us-intl/
├── .XCompose
├── README.md
├── LICENSE
├── install.sh
├── uninstall.sh
└── tests/
    └── combinations.md
```

## Instalação rápida

Você pode instalar diretamente do GitHub sem clonar o repositório:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main/install.sh)"
```

O instalador baixa a versão atual do `.XCompose` diretamente deste repositório.

### O instalador sobrescreve meu ~/.XCompose?

Sim, o arquivo `~/.XCompose` precisa ser substituído para que esta configuração passe a ser usada.

Por segurança, **na primeira instalação**, se já existir um `~/.XCompose`, o script preserva uma cópia do arquivo original em:

```text
~/.local/state/xcompose-ptbr-us-intl/original.XCompose
```

Esse backup original não é sobrescrito nas atualizações seguintes.

Ao executar o `uninstall.sh`, o arquivo original é restaurado automaticamente.

Se o `~/.XCompose` instalado já for idêntico à versão atual do repositório, o script simplesmente informa que ele já está atualizado.

## Instalação usando git

Se preferir clonar o projeto:

```bash
git clone https://github.com/dbmello75/xcompose-ptbr-us-intl.git
cd xcompose-ptbr-us-intl
bash install.sh
```

O instalador também garante que esta variável esteja configurada no `~/.profile`:

```bash
export XCOMPOSEFILE="$HOME/.XCompose"
```

Depois da instalação, faça logout e login novamente.

## Instalação manual

Também é possível instalar apenas o arquivo:

```bash
curl -fsSL https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main/.XCompose -o ~/.XCompose
```

Nesse caso, o gerenciamento de backup fica por sua conta.

## Desinstalação

Se você clonou o repositório:

```bash
bash uninstall.sh
```

Se instalou diretamente com `curl`, pode executar o desinstalador da mesma forma:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main/uninstall.sh)"
```

Se existia um `~/.XCompose` antes da primeira instalação, ele será restaurado.

## Atualização

Para atualizar para a versão mais recente, basta executar novamente:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/dbmello75/xcompose-ptbr-us-intl/main/install.sh)"
```

O backup da configuração original continua preservado.

## Testes

Uma matriz de testes está disponível em [tests/combinations.md](tests/combinations.md).

Teste rápido:

```text
' + a   → á
' + e   → é
' + c   → ç
~ + a   → ã
~ + o   → õ
^ + a   → â
^ + e   → ê
^ + o   → ô
` + a   → à
' + m   → 'm
' + s   → 's
```

Também vale testar palavras reais:

```text
ação
coração
informação
você
português
São Paulo

I'm
it's
don't
we'll
John's
```

## Compatibilidade

O comportamento do XCompose pode variar entre ambientes gráficos e toolkits.

A configuração é voltada para sistemas Linux que utilizem uma pilha de entrada compatível com XCompose.

Aplicativos executando via X11, Wayland, GTK, Qt, Chromium/Electron ou frameworks de método de entrada podem não interpretar as regras exatamente da mesma forma.

Se encontrar um problema de compatibilidade, abra uma issue informando:

- distribuição Linux e versão;
- ambiente gráfico;
- X11 ou Wayland;
- layout do teclado;
- aplicativo em que o problema ocorre;
- se a combinação funciona normalmente em outros aplicativos.

## Projetos semelhantes

Existem outros projetos e configurações da comunidade com objetivo semelhante para usuários de PT-BR em teclado US International.

Este projeto adota uma abordagem intencionalmente minimalista: mantém a tabela Compose padrão do sistema e sobrescreve somente os casos necessários para uma experiência confortável em português do Brasil e inglês.

## Licença

Este projeto é distribuído sob a licença MIT.

Consulte o arquivo [LICENSE](LICENSE).
