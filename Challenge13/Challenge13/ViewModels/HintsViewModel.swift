//
//  HintsViewModel.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

/*
 Na sua VIEW, quando o card for clicado, você só precisa chamar:
  viewModel.toggleHint(hint)
 ps: vc precisa passar o hint que foi clicado
 */


import Foundation

class HintsViewModel {
    var hints: [Hint] = [
        Hint(title: "Como usar o app", description: "Explore os recursos e registre seus pensamentos."),
        Hint(title: "Gerenciar emoções", description: "Escreva regularmente para acompanhar seus sentimentos."),
        Hint(title: "Dicas de foco", description: "Use o app diariamente por alguns minutos.")
    ]
    
    //UI State
    /*A ideia é que eu não guardo o estado de ‘expandido’ dentro de cada card. Em vez disso, eu guardo só um selectedHintID,
    que representa qual card está aberto no momento.*/
    var selectedHintID: UUID?
    
    //MARK: - Actions with hints list
    func toggleHint(_ hint: Hint) {
        
        //se o card ja estava aberto, a função fecha o card (o valor recebe nil)
        if selectedHintID == hint.id {
            selectedHintID = nil
        } else {
            //se ele não tiver aberto, ela salva o id do card
            selectedHintID = hint.id
        }
    }
}
