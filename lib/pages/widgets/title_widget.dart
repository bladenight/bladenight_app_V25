/*
MIT License

Copyright © 2019 Mitesh Chodvadiya

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or modified
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Finally, this software is helping the developer to solve their project issue and
learning, it's free but doesn't mean to sell and earning, please respect the
developer community.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TitleView extends StatelessWidget {
  const TitleView({
    required this.animationController,
    required this.animation,
    this.titleTxt = '',
    this.subTxt = '',
    super.key,
  });

  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return CupertinoScaffold(
          transitionBackgroundColor:
              CupertinoTheme.of(context).barBackgroundColor,
          body: FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              subTxt,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .fontFamily,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                color: CupertinoTheme.of(context)
                                    .primaryContrastingColor,
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 26,
                              child: Icon(
                                Icons.arrow_forward,
                                color: CupertinoTheme.of(context)
                                    .primaryContrastingColor,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
