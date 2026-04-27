//
//  Hints.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import Foundation

// MARK: - Model
/// # Model - Hint
/// Modelo de dados para estruturar as dicas do usuário, possuindo um id, titulo da dica e descrição.
/// Usa `Identifiable` para permitir id e `Equatable` para permitir comparações de valor.
/// ## Usado em:
/// - ``HintsViewModel``
struct Hint: Identifiable, Equatable {
    /// ID da dica, permite diferenciar, pois é um valor único
    let id: UUID
    /// Título da dica
    let title: String
    /// Descrição da dica
    let description: String
    /// Icone
    let icon: String
}

