# CineTrackSwiftUI

**CineTrackSwiftUI** é um aplicativo de rastreamento de filmes desenvolvido com SwiftUI, que permite aos usuários explorar filmes populares, favoritos e visualizar informações detalhadas sobre cada filme. O projeto utiliza `Core Data` para persistência local de dados e caching de imagens para melhorar a performance.


## 🎨 Screenshots

| Filmes Mais Votados | Buscar Filmes | Detalhes do Filme |
|:-------------------------:|:-------------------------:|:-------------------------:|
| <img src="https://i.imgur.com/iuCKwOr.png" width="200"/> | <img src="https://i.imgur.com/Lrvdbkn.png" width="200"/> | <img src="https://i.imgur.com/0KIsn6g.png" width="200"/>



## 📱 Features

- Exibição de filmes populares obtidos da API TMDB.
- Persistência de dados de filmes usando `Core Data` para reduzir chamadas desnecessárias à API.
- Armazenamento em cache de imagens de pôsteres de filmes usando `NSCache`.
- Interface moderna e fluida utilizando SwiftUI.
- Atualizações automáticas apenas quando há novas informações (evita buscas frequentes na API).

## 🛠️ Tecnologias Utilizadas

- **SwiftUI**: Para construir a interface de usuário reativa e declarativa.
- **Core Data**: Para persistência de dados de filmes localmente no dispositivo.
- **NSCache**: Para cache de imagens dos pôsteres de filmes, melhorando a performance.
- **URLSession**: Para realizar requisições HTTP para a API de filmes.
- **MVVM (Model-View-ViewModel)**: Arquitetura para organização do código.
  
## 🏗️ Arquitetura

O projeto segue o padrão **MVVM** (Model-View-ViewModel) combinado com Core Data para manter a organização, separação de responsabilidades e facilitar o teste e manutenção.

### Camadas:

- **Model**: Representa os dados do filme e as operações relacionadas ao Core Data.
- **ViewModel**: Contém a lógica de negócio, responsável por se comunicar com a API, salvar e buscar dados no Core Data.
- **View**: Camada de apresentação, representada pelas views SwiftUI que exibem as informações dos filmes.

## 🔧 Instalação

1. Clone o repositório para sua máquina local:

    ```bash
    git clone https://github.com/SeuUsuario/CineTrackSwiftUI.git
    ```

2. Acesse a pasta do projeto:

    ```bash
    cd CineTrackSwiftUI
    ```

3. Abra o projeto no Xcode:

    ```bash
    open CineTrackSwiftUI.xcodeproj
    ```

4. Execute o projeto no simulador ou dispositivo.

## 🔑 Pré-requisitos

- **Xcode 13** ou superior.
- **iOS 15** ou superior para suporte ao SwiftUI e às novas APIs do Core Data.
- **Chave de API da TMDB**: Você precisará se registrar no [The Movie Database](https://www.themoviedb.org/) e gerar uma chave de API.

### Configurando a chave de API

1. Crie um arquivo chamado `Constants.swift` na pasta principal do projeto.
2. Adicione o seguinte código com a sua chave da API:

    ```swift
    struct Constants {
        static let apiKey = "SUA_CHAVE_API_AQUI"
    }
    ```

## 🚀 Funcionalidades Futuras

- **Busca por filmes**: Implementar funcionalidade de busca por filmes através de um campo de pesquisa.
- **Categorias de filmes**: Exibir filmes por categorias, como 'Em Cartaz', 'Top Rated', etc.
- **Notificações**: Notificar o usuário sobre novos lançamentos ou filmes adicionados aos favoritos.

## 🤝 Contribuição

Contribuições são bem-vindas! Se você tiver sugestões de melhorias, correções de bugs ou novas funcionalidades, fique à vontade para abrir uma [issue](https://github.com/SeuUsuario/CineTrackSwiftUI/issues) ou um [pull request](https://github.com/SeuUsuario/CineTrackSwiftUI/pulls).

1. Faça um fork do projeto.
2. Crie uma nova branch para sua feature (`git checkout -b minha-feature`).
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`).
4. Push para a branch (`git push origin minha-feature`).
5. Abra um Pull Request.
