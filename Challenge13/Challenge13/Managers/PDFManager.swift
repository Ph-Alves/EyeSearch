//
//  PDFManager.swift
//  Challenge13
//
//  Created by Raquel Souza on 13/04/26.
//

import Foundation
import UIKit
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Manager
final class PDFManager: PDFManaging {
    // MARK: - Functions
    func generatePDF(quantity: Int) -> Data? {
        //MARK: Configuração do adesivo
        
        //imagem do STICKER que será utilizada em todas as impressões, caso o sistema não carregue a imagem, return data.
        guard let sticker = UIImage(named: "sticker") else {
            return nil
        }
        //Tamanho do Sticker e espaçamento entre eles
        let stickerSize = CGSize(width: 200, height: 200)
        let spacing: CGFloat = 20
        
        //MARK: Configuração do tamanho da folha do PDF
        
        // Tamanho da folha A4
        let pageWidth: CGFloat = 595.2
        let pageHeight: CGFloat = 841.8
        
        //renderizando a página do PDF.
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)) // A4
        
        //MARK: Criação do conteúdo do PDF
        let data = pdfRenderer.pdfData { context in
            
            //criação da página no PDF
            context.beginPage()
            
            // Margem para os stickers não ficarm colados na borda da folha
            let margin: CGFloat = 20
            
            var x: CGFloat = margin
            var y: CGFloat = margin
            
            for _ in 0..<quantity {
                //Cria uma área na posição (x, y) com um tamanho específico e desenha o adesivo dentro dela
                let stickerRect = CGRect(origin: CGPoint(x: x, y: y), size: stickerSize)
                sticker.draw(in: stickerRect)
                
                //aqui eu faço os adesivos "andarem pela página, o X atualiza toda vez que um adesivo é adicionado.
                x += stickerSize.width + spacing
                
                // quebra de linha
                if x + stickerSize.width > pageWidth {
                    //o X volta ao seu valor inicial
                    x = margin
                    //atualizando o Y para iniciar uma nova linha
                    y += stickerSize.height + spacing
                }
                
                // nova página, x e y voltam ao seu valor inicial
                if y + stickerSize.height > pageHeight {
                    context.beginPage()
                    x = margin
                    y = margin
                }
            }
        }
        return data
    }
}

// MARK: - CUSTOM PDF
// Struct para permitir exportar o doc pronto

struct CustomPDFDoc: Transferable {
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { documento in
            documento.data
        }
        .suggestedFileName("Adesivos.pdf")
    }
}
