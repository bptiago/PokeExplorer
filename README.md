# PokéExplorer

O PokéExplorer é um aplicativo iOS que permite explorar uma lista completa de Pokémons e visualizar seus detalhes. Através de um sistema de autenticação, o usuário pode criar uma conta para salvar e gerenciar uma coleção pessoal de seus Pokémon favoritos.

## Entregáveis

Projeto realizado por: Bernardo Jakubiak, Danilo Garabetti, Henrique Grigoli e Tiago Prestes

- Documentação via README.md
- Vídeo demonstrativo: <a href="https://youtu.be/gvSunYM-lsE">YouTube</a>

## Funcionalidades

- Chamadas via `PokeAPI` com sistema de paginação (item de criatividade)
- Persistência de dados locais via `SwiftData`
- Cadastro e autenticação de usuário
- Visualização e opção de favoritar Pokémons
- Arquitetura MVVM, onde há um `ViewModel` para cada view principal
- Utilização de `AdaptiveColumn` para Grid responsiva
- Definição de `Deisgn Tokens` para estilização das interfaces

## Escolha da API

Foi utilizada somente a `PokeAPI` para buscar informações de Pokémon. Ela é uma API pública e bem documentada, o que facilitou bastante o seu uso e foi um fator muito importante na sua escolha. 

No quesito de dados, foram utilizadas duas estruturas de resposta para o aplicativo: `PokemonResponse` e `ListedPokemonResponse`.

```swift
struct PokemonResponse: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let order: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonType]
    let moves: [PokemonMove]
    let abilities: [PokemonAbility]
}
```

A `PokemonResponse` é utilizada para capturar dados mais específicos do Pokémon em endpoints `GET https://pokeapi.co/api/v2/pokemon/{id or name}/` . As informações obtidas nessa estrutura são exibidas dinamicamente na tela de detalhes sobre um Pokémon - `PokemonDetailsView`.

```swift
struct ListedPokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ListedPokemon]
}
```

A `ListedPokemonResponse` é utilizada para receber listas com informações gerais de Pokémon considerando o endpoint com paginação `GET https://pokeapi.co/api/v2/pokemon?limit=8&offset=0`.

## Arquitetura do Aplicativo

O projeto segue a arquitetura MVVM (Model-View-ViewModel) e inclui a implementação de um `ViewModel` para cada view principal.

## Implementação do SwiftData

A persistência de informações via SwiftData envolve um modelo de classes com duas estruturas:

```swift
@Model
class Usuario {
    
    @Attribute(.unique) var id: UUID = UUID()
    var username: String
    @Attribute(.unique) var email: String
    var senha: String
    
    init(username: String, email: String, senha: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.senha = senha
    }
}
```

```swift
@Model
class Favorito {
    
    @Attribute(.unique) var id: Int
    var name: String
    var url: String
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
```

A persistência é realizada a partir da captura de um objeto `modelContext` no enviroment das views - isso é possível devido a inicialização de um `ModelContainer` no arquivo main do aplicativo. A captura é feita assim: `@Environment(\.modelContext) **var** modelContext` , e possibilita o uso operações de SEARCH, INSERT, DELETE e PUT no modelo de dados local.

```swift
func insertUser() {
    let user = Usuario(username: viewModel.username, email: viewModel.email.lowercased(), senha: viewModel.password)
    modelContext.insert(user)
    try? modelContext.save()
}
```

Aqui temos função para salvar um usuário cadastrado. Ela irá pegar o valor dos estados de todos os inputs importantes do formulário, criar uma estrutura `Usuario` e fazer a inserção dela no contexto de dados.

```swift
@Query private var usuarios: [Usuario]

func findUser(email: String, password: String) -> Usuario? {
    let predicate = #Predicate<Usuario> { user in
        user.email == email && user.senha == password
    }
    var descriptor = FetchDescriptor<Usuario>(predicate: predicate)
    descriptor.fetchLimit = 1
    do {
        let users = try modelContext.fetch(descriptor)
        return users.first
    } catch {
        print("Error fetching user by email: \(error)")
        return nil
    }
}
```

Para a autenticação, é feita a busca de todos os usuários salvos no contexto via `@Query private var usuarios: [Usuario]` . Em cima da lista retornada pelo `modelContext`, é aplicada uma função de filtragem que utiliza o e-mail e senha inseridos no formulário de login como parâmetro.

## Design Tokens

Para a padronização de design, foram criados enums de estilização no arquivo `DesignTokens.swift` .

```swift
enum MyColors {
    static let primary = Color.white
    static let secondary = Color.gray
    static let tertiary = Color.secondary
    
    static let accent = Color.green
    static let warning = Color.red
    
    static let filledButton = accent
    static let disabledButton = Color.gray
}

enum MySpacings {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let big: CGFloat = 24
    static let bigger: CGFloat = 32
}
```

A aplicação deles é muito simples e foi bem útil para a personalização das views. Aqui está um exemplo de implementação dentro de uma view:

```swift
Text("PokéExplorer")
    .font(.largeTitle.bold())
    .foregroundStyle(MyColors.primary)

Text("Procure por Pokémons e divirta-se! Quem sabe você não encontra seus favoritos?")
    .font(.body)
    .foregroundStyle(MyColors.secondary)
```

## Item de Criatividade

Foi escolhido o item de paginação para carregar a lista de Pokémons como item de criatividade. A implementação foi feita utilizando um endpoint `GET https://pokeapi.co/api/v2/pokemon` com os parâmetros de busca `limit` e `offset`.

- `limit` é utilizado para limitar a quantidade de Pokémons que serão retornados na chamada da API.
- `offset` é um indicador que será utilizado para deslocar o range de busca de Pokémons. Desse modo, se `offset = 0` : o range de busca de Pokémons será entre os índices zero e limit. Agora, se `offset = 8` : o range de busca será entre os índices oito e limit.

Vamos lá… Na view de listagem de Pokémons, o carregamento inicial faz uma chamada ÚNICA da função `getPokemons()` para retornar uma lista contendo oito (`limit`) Pokémons iniciais. Acontece que o usuário tem a opção de carregar mais Pokemóns nessa lista através de um botão dentro da view de listagem. Basicamente, o clique nesse botão aciona a função `loadMorePokemons()` e faz uma busca de Pokemóns utilizando parâmetros de paginação dinâmicos `limit` e `offset` disponibilizados pela `PokeAPI`.

```swift
class SearchViewModel: ObservableObject {
    @Published var pokemons: [ListedPokemon] = []
    private var offset = 8
    private var limit = 8
    private(set) var hasLoaded = false
        
    func getPokemons() async {
        if hasLoaded { return }
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ListedPokemonResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.pokemons = response.results
                self.hasLoaded = true
            }
            
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadMorePokemons() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ListedPokemonResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.pokemons.append(contentsOf: response.results)
                self.offset += self.limit
            }
            
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
```
