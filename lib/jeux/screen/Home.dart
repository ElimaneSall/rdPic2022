import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class ChessGame extends StatefulWidget {
  const ChessGame({Key? key}) : super(key: key);

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  ChessBoardController controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chess Game"),
        backgroundColor: AppColors.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeApp()));
          },
          child: Icon(Icons.home // add custom icons also
              ),
        ),
      ),
      body: Center(
        child: ChessBoard(
          controller: controller,
          boardColor: BoardColor.darkBrown,
          boardOrientation: PlayerColor.white,
          onMove: () {
            //
          },
        ),
      ),
    );
  }
}
