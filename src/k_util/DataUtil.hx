package k_util;

import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ds.Map;
import k_util.UserStatics;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class DataUtil{

    public static function getData(path:String):Array<String> {
        UserStatics.userModes = new Map();
        #if sys
        if(!FileSystem.exists(path))
            return [];

        return File.getContent(path).replace("\n", "").replace(" ", "").replace(String.fromCharCode(9), "").replace(String.fromCharCode(10), "").replace(String.fromCharCode(11), "")
        .replace(String.fromCharCode(12), "").replace(String.fromCharCode(13), "").replace(String.fromCharCode(32), "").split(",");
        #end
        return [];
    }

    /**
        @return true if there is no data loaded yet \\ false otherwise
    **/
    public static function checkData():Bool
    {
        if(UserStatics.data.length < 1)
            Dialogs.messageBox("Primero Carga datos desde un archivo o de forma manual", "Error", MessageBoxType.TYPE_ERROR, true);

        return UserStatics.data.length < 1;
    }
    public static function fastCheckData():Bool{return UserStatics.data.length < 1;}

    public static function getOrderedData(numbers:Array<Float>):Array<Float>
    {
        numbers.sort(function (a, b)
        {
            if (a < b)
                return -1;
            else if (a > b)
                return 1;
            else
                return 0;
        });
        return numbers;
    }

    public static function mean(numbers:Array<Float>):Float {
        var result:Float = 0;
        for(num in numbers)
            result+=num;
        
        return result/numbers.length;
    }
    public static function getRange(numbers:Array<Float>):Float
    {
        numbers = getOrderedData(numbers);
        return numbers[numbers.length-1] - numbers[0];
    }

    public static function getVariance(values:Array<Float>):Float
    {
        final daMean = mean(values);
        var result:Float = 0;
        for(value in values)
        {
            final mid = (value-daMean);
            result += (mid*mid)/(values.length-1);
        }
        return result;
    }
    public static function deviation(value:Float){return Math.sqrt(value);}

    public static function medianDeviation(values:Array<Float>):Float
    {
        final daMean = mean(values);
        var result:Float = 0;
        for(value in values)
            result += Math.abs((value-daMean));
        
        return result/values.length;
    }
    public static function coeffOfVar(value:Float):Float{return (value/mean(UserStatics.data)*100);}
}