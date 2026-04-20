# ``EyeSearch``

EyeSearch é um projeto feito para pessoas com baixa visão, a conseguirem encontrar seus objetos adesivados
caso mudem de lugar, ou tenham deixado cair.

## Overview

O projeto conta com 5 funcionalidades principais:
- busca de objeto adesivado perdido
- geração de pdf com adesivo para recorte, podendo selecionar quantidade
- dicas prontas de como configurar o dispositivo
- chatbot para conversar sobre dúvidas gerais e específicas
- configurações para ajustar haptics e som

### Architecture
O projeto é feito seguindo a arquitetura MVVM-C, se aproveitando ao máximo de managers como ferramentas.
1. O coordinator define a navegação 
2. A view aparece 
3. Solicita os dados para a viewModel e outras funções
4. A viewModel usa os models e managers

## Topics

### Coordinator (Navegação)
- ``Coordinator``
- ``DependencyContainer``

### Views (Telas)
- ``HomeView``
- ``SearchObjectView``
- ``StickerView``
- ``ChatView``
- ``HintsView``
- ``SettingsView``
- ``PrintStickerView``

### Components (Components reutilizáveis)
- ``BiggerCardView``
- ``CompactCardView``
- ``HintCardView``
- ``ReturnButton``

### ViewModels (Gerenciadores, tira responsabilidade da view)
- ``HomeViewModel``
- ``SearchObjectViewModel``
- ``StickerViewModel``
- ``HintsViewModel``
- ``SettingsViewModel``

### Protocols (Protocolos de managers)
- ``CameraManaging``
- ``FoundationsManaging``
- ``HapticsManaging``
- ``MLModelManaging``
- ``PDFManaging``
- ``SettingsManager``
- ``SoundManaging``

### Managers (Ferramentas, utilitários)
- ``CameraManager``
- ``MLModelManager``
- ``FoundationsManager``
- ``PDFManager``
- ``HapticsManager``
- ``SoundManager``
- ``SettingsManager``

### Models (Dados)
- ``ChatMessage``
- ``Hint``
- ``UserSettings``
