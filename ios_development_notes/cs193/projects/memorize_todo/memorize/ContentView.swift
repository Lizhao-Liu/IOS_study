//
//  ContentView.swift
//  memorize
//
//  Created by Lizhao Liu on 03/04/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
    @State var emojiCount = 8
    var body: some View{
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                ForEach(viewModel.cards){ card in //函数传参
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.red) //颜色覆盖
        .font(.largeTitle)
        .padding(.horizontal)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                //STROKE和strokeborder区别
                shape.strokeBorder(lineWidth: 3) //use .fill() after stroke 表示fill这个边框，比如添加渐变图案等等
                Text(card.content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
//        .onTapGesture {
//            isFaceUp = !isFaceUp
//        }
        
    }
}




//配置previews，使他展现contentview的code内容
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        //创建多种preview
        ContentView(viewModel: game)
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portraitUpsideDown)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
