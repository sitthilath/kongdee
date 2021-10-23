import 'package:flutter/material.dart';

class WidgetStatic{

 static Widget buildLoadingCat(){
  return Image.asset(
     "asset/gif/cat_loading.gif",
     height: 200,
     width: 200,
     fit: BoxFit.fill,
   );
 }

 static Widget buildLoadingCatSmall(){
   return Image.asset(
     "asset/gif/cat_loading.gif",
     height: 100,
     width: 100,
     fit: BoxFit.fill,
   );
 }

}