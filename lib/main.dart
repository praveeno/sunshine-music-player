import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MusicPlayer(),
    ),
  );
}

Widget whiteIcon(IconData icon, {size = 24}) {
  return Icon(icon, color: Colors.white, size: size);
}

Widget whiteText(text, {size: 14}) {
  return Text(text, style: TextStyle(color: Colors.white, fontSize: size));
}

Widget nextPlay = Container(
    decoration: BoxDecoration(
      color: Colors.black,
    ),
    padding: const EdgeInsets.all(4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      whiteIcon(Icons.queue_music),
      whiteText("Next: Lord Shiva Bhajan"),
      whiteIcon(Icons.expand_less)
    ]));

Widget playMenu = Container(
    decoration: BoxDecoration(color: Colors.black),
    padding: const EdgeInsets.all(12),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      whiteIcon(Icons.thumb_down),
      whiteIcon(Icons.skip_previous, size: 22),
      whiteIcon(Icons.play_arrow, size: 48),
      whiteIcon(Icons.skip_next, size: 22),
      whiteIcon(Icons.thumb_up),
    ]));

Widget playSlider = Container(
    decoration: BoxDecoration(color: Colors.black),
    padding: const EdgeInsets.only(left: 36, right: 36),
    child: Row(children: [
      whiteText("0:00"),
      Expanded(
          child: Slider(
        min: 0,
        max: 100,
        value: 50,
        onChanged: (value) {},
      )),
      whiteText("4:06")
    ]));

Widget playTitle = Container(
    decoration: BoxDecoration(color: Colors.black),
    padding: const EdgeInsets.all(4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      whiteIcon(Icons.error_outline),
      Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text("Lord Krishna flute..",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600))),
      whiteIcon(Icons.more_vert)
    ]));

Widget playerImage = Image.network(
  "https://i.pinimg.com/originals/57/f6/a7/57f6a7dd3bd91a978083d0ef16bc3d93.png",
  // height: 314,
  width: double.infinity,
  fit: BoxFit.contain,
  loadingBuilder:
      (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
            : null,
      ),
    );
  },
);

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicPlayerState();
}

Widget hideableContainer = Container(
  height: 0,
);

class _MusicPlayerState extends State<MusicPlayer>
    with TickerProviderStateMixin {
  double position = 0;
  double _pos;
  bool swipeStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: playerImage),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: swipeStart ? hideableContainer : playTitle,
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: swipeStart ? hideableContainer : playSlider,
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: swipeStart ? hideableContainer : playMenu,
          ),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragUpdate: (DragUpdateDetails details) => {
                    print(details.globalPosition.dy),
                    setState(() => {
                          _pos = MediaQuery.of(context).size.height -
                              details.globalPosition.dy,
                          if (_pos < 400 && _pos > 50)
                            {
                              position = _pos,
                              if (position < 50) {swipeStart = false}
                            }
                        })
                  },
              onVerticalDragStart: (details) =>
                  {setState(() => swipeStart = true)},
              onVerticalDragCancel: () => {setState(() => swipeStart = false)},
              onVerticalDragEnd: (details) => {
                    setState(() => {
                          if (position > 300)
                            {position = 400, swipeStart = true}
                          else
                            {position = 50, swipeStart = false}
                        })
                  },
              child: swipeStart
                  ? Container(
                      width: double.infinity,
                      height: position,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: whiteText("Next Songs", size: 30),
                              ),
                              IconButton(
                                icon: whiteIcon(Icons.close),
                                onPressed: () => {
                                  setState(
                                      () => {swipeStart = false, position = 50})
                                },
                              )
                            ],
                          )
                        ],
                      ))
                  // vsync: this,
                  // duration: new Duration(seconds: 1))
                  : nextPlay)
        ],
      ),
    );
  }
}
