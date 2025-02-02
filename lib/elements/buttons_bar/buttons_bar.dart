import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/buttons_bar/settings_widget.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import '../../global_keys.dart';
import 'indicator_raised_button.dart';

class MyBottomBar extends StatelessWidget {
  final bool isEditor;
  const MyBottomBar(this.isEditor);

  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double fontSize = height > width ? (width/25)/1.1 : (height/25)/1.1;
    //print("buttonsBar, h: $height, w: $width");
    return Container(
      padding: EdgeInsets.symmetric(vertical: isEditor ? 5 : 0),
      //decoration: bottomDecoration,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: height > width ? 0.045*height : 0.045 * width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Visibility(
              visible: !isEditor,
              child: Expanded(
                child: RaisedButton(
                  key: resetKey, ///////////////////////////////////
                    elevation: 5,
                    child: FittedBox(fit: BoxFit.fitHeight, child: Text("Reset", style: mainText.copyWith(fontSize: fontSize),)),
                    onPressed: !providerModel.selected ? null : () {
                      showDialog(
                          context: context,
                      builder: (context) {
                            return AlertDialog(
                              shape: alertShape,
                              backgroundColor: alertBackgroundColor,
                              title: Text("Reset selected fixtures?", style: mainWhiteText,),
                              actions: [
                                IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: () {
                                  Controller.setReset();
                                  Navigator.pop(context);
                                })
                              ],
                            );
                      }
                      );
                    }),
              ),
            ),
            Visibility(
              visible: !isEditor,
              child: Expanded(
                child: RaisedButton(
                  key: areaKey, ////////////////////////////////////////////////////////
                  elevation: 5,
                    child: Text("Area", style: mainText.copyWith(fontSize: fontSize),),
                    onPressed: !Controller.providerModel.selected ? null : () {
                      showDialog(
                          context: context,
                        builder: (context) {
                          Settings set = providerModel.getFirstChecked().ramSet;
                          RangeValues val = RangeValues(set.startPixel.roundToDouble(), set.endPixel.roundToDouble());
                            return Row(
                              children: <Widget>[
                                Material(
                                  color:Colors.transparent,
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                  //color:Colors.red,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("${val.start.round()}"),
                                                  ),
                                                  decoration: roundedDecoration,
                                                ),
                                                Expanded(
                                                  child: RangeSlider(
                                                      values: val,
                                                      min: 0,
                                                      max: set.pixelCount.roundToDouble(),
                                                      divisions: set.pixelCount,
//                                                        labels: RangeLabels(
//                                                          val.start.toString(),
//                                                          val.end.toString()
//                                                        ),
                                                      onChanged: (values) {
                                                        val = values;
                                                        setState(() {});
                                                      },
                                                  onChangeEnd: (values) {
                                                        Controller.setArea(set.pixelCount, values);
                                                  },
                                                  ),
                                                ),
                                                Container(
                                                    decoration: roundedDecoration,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${val.end.round()}"),
                                                    )),
                                              ],
                                            );
                                          }
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      );
                    }),
              ),
            ),
            Expanded(child: SettingsWidget(fontSize)),
            Expanded(
              child: StatefulBuilder(builder: (context, setState) {
                onChanged(bool value) {
                  Controller.highlite = value;
                  if(value) {
                    Controller.setHighlite();
                  }
                  else {
                    Controller.unsetHLAll();
                  }
                  setState(() {});
                }
                return IndicatorRaisedButton(label: "HL", value: Controller.highlite, onPressed: onChanged, fontSize: fontSize,);
              }),
            ),
            Expanded(
              child: RaisedButton(
                key: selectKey, ////////////////////////////////
                shape: buttonShape,
                elevation: 5,
                  child: Icon(Icons.select_all, size: fontSize*1.4,),
                  onPressed: () {
                    Controller.selectAll();
                  }),
            ),
            Expanded(
              child: RaisedButton(
                key: deselectKey, ///////////////////////////
                  color: Controller.areNotSelected() ? buttonColor : buttonSelectedColor,
                shape: Controller.areNotSelected() ? buttonShape : buttonSelectShape,
                elevation: 5,
                  child: Icon(Icons.clear, size: fontSize*1.4, color: Controller.areNotSelected() ? Colors.black : accentColor,),
                  onPressed: () {
                    Controller.deselectAll();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}


