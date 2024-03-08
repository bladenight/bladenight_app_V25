import 'spring_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_settings/app_constants.dart';

final Map<int, double> _correctSizes = {};
final PageController _pageController = PageController(keepPage: true);

class FastCustomColorPicker extends StatefulWidget {
  @override
  State<FastCustomColorPicker> createState() => _FastCustomColorPicker();

  final Color selectedColor;
  final IconData? icon;
  final Function(Color) onColorSelected;

  const FastCustomColorPicker({
    super.key,
    this.icon,
    this.selectedColor = Colors.white,
    required this.onColorSelected,
  });
}

//FastCustomColorPicker for custom colors because yellow is 'me' color. Grays are not useful
//No customisation of selectable colors
class _FastCustomColorPicker extends State<FastCustomColorPicker> {
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: SelectedColor(
                    icon: widget.icon,
                    selectedColor: widget.selectedColor,
                  ),
                ),
                Expanded(
                    //TODO resize on iPad - it's very small inside sized box on friendsEditWidget
                    child: SizedBox(
                  height: 52,
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (int page) {
                      setState(() {
                        _activePage = page;
                      });
                    },
                    controller: _pageController,
                    physics: const PageScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      switch (index) {
                        case 0:
                          return Row(
                            children:
                                createColors(context, ColorConstants.colors1),
                          );
                        case 1:
                          return Row(
                            children:
                                createColors(context, ColorConstants.colors2),
                          );
                        case 2:
                          return Row(
                            children:
                                createColors(context, ColorConstants.colors3),
                          );
                        default:
                          return Row(
                            children:
                                createColors(context, ColorConstants.colors1),
                          );
                      }
                    },
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      //not working _
                       /* _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);*/
                    },
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor:
                          _activePage == index ?  CupertinoTheme.of(context).primaryColor :
                          CupertinoTheme.of(context).barBackgroundColor ,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createColors(BuildContext context, List<Color> colors) {
    double size = _correctSizes[colors.length] ??
        correctButtonSize(
          colors.length,
          MediaQuery.of(context).size.width,
        );
    return [
      for (var c in colors)
        SpringButton(
          SpringButtonType.onlyScale,
          Padding(
            padding: EdgeInsets.all(size * 0.1),
            child: AnimatedContainer(
              width: size,
              height: size,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  width: c == widget.selectedColor ? 4 : 2,
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: size * 0.1,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            widget.onColorSelected.call(c);
          },
          useCache: false,
          scaleCoefficient: 0.9,
          duration: 1000,
        ),
    ];
  }

  double correctButtonSize(int itemSize, double screenWidth) {
    double firstSize = 52;
    double maxWidth = screenWidth - firstSize;
    bool isSizeOkay = false;
    double finalSize = 48;
    do {
      finalSize -= 2;
      double eachSize = finalSize * 1.2;
      double buttonsArea = itemSize * eachSize;
      isSizeOkay = maxWidth > buttonsArea;
    } while (!isSizeOkay);
    _correctSizes[itemSize] = finalSize;
    return finalSize;
  }
}

class SelectedColor extends StatelessWidget {
  final Color selectedColor;
  final IconData? icon;

  const SelectedColor({super.key, required this.selectedColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: selectedColor,
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black38,
          ),
        ],
      ),
      child: icon != null
          ? Icon(
              icon,
              color: selectedColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              size: 22,
            )
          : null,
    );
  }
}
