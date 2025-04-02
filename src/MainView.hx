package ;

import k_util.UserStatics;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.MessageBox;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.components.Label;
import haxe.ui.notifications.NotificationManager;
import haxe.ui.notifications.NotificationType;
import k_util.DataUtil;

using StringTools;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    public function new() {
        super();
        loadFile.onClick = function(e)
        {
            resetDisplay();
            UserStatics.data = [];
            var helper = new OpenFileDialog();
            helper.show();
            helper.onDialogClosed = function (event) {
                var files = helper.selectedFiles;
                if(event.canceled || files == null)
                {
                    Dialogs.messageBox("Archivo Invalido", "Error", MessageBoxType.TYPE_ERROR, true);
                    return;
                }
                if(!files[0].name.endsWith(".txt")){
                    Dialogs.messageBox("Archivo Invalido (Nombre del archivo:" + files[0].name+ ")", "Error", MessageBoxType.TYPE_ERROR, true);
                    return;
                }
                for(value in DataUtil.getData(files[0].fullPath))
                {
                    if(value.length > 1)
                    {
                        for(char in value.split(""))
                        {
                            if((char.charCodeAt(0) < 48 || char.charCodeAt(0) > 57) && char.charCodeAt(0) != 44 && char.charCodeAt(0) != 46)
                            {
                                Dialogs.messageBox("Su archivo contiene caracteres invalidos", "Error", MessageBoxType.TYPE_ERROR, true);
                                return;
                            }
                        }
                    }
                    else
                    {
                        if(value == "" || value == null)
                            continue;

                        if((value.charCodeAt(0) < 48 || value.charCodeAt(0) > 57) && value.charCodeAt(0) != 44)
                        {
                            Dialogs.messageBox("Su archivo contiene caracteres invalidos", "Error", MessageBoxType.TYPE_ERROR, true);
                            return;
                        }
                    }
                    UserStatics.data.push(Std.parseFloat(value));
                }
                NotificationManager.instance.addNotification({
                    title: "Lectura de archivo Exitosa",
                    body: "Ahora puede calcular las medidas de dispersion",
                    type: NotificationType.Success
                });
                trace(UserStatics.data);
            }
        }
        loadRaw.onClick = function(e){
            resetDisplay();
            if(rawData.text == "" || rawData.text == null)
            {
                Dialogs.messageBox("Introduzca datos Validos en la caja de texto", "Error", MessageBoxType.TYPE_ERROR, true);
                return;
            }
            UserStatics.data = [];
            for(value in rawData.text.split(","))
            {
                if(value == "")
                    continue;

                UserStatics.data.push(Std.parseFloat(value));
            }
            NotificationManager.instance.addNotification({
                title: "Lectura de datos Exitosa",
                body: "Ahora puede calcular las medidas de dispersion",
                type: NotificationType.Success
            });
            trace(UserStatics.data);
        }

        mean.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            meanDisplay.htmlText = "El promedio es: "+ DataUtil.mean(UserStatics.data);
        }
        range.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            rangeDisplay.htmlText= "El rango es: "+DataUtil.getRange(UserStatics.data);
        }
        variance.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            varianceDisplay.htmlText = "La Varianza es: "+ DataUtil.getVariance(UserStatics.data);
        }
        standartDeviation.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            standartDeviationDisplay.htmlText = "La Desviacion Estandar es: " + DataUtil.deviation(DataUtil.getVariance(UserStatics.data));
        }
        coefOfVar.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            coefOfVarDisplay.htmlText = "El coeficiente de variacion es: "+ DataUtil.coeffOfVar(DataUtil.deviation(DataUtil.getVariance(UserStatics.data)));
        }
        medianDeviation.onClick = function (e)
        {
            if(DataUtil.checkData())
                return;

            medianDeviationDisplay.htmlText="La desviacion Media es: " + DataUtil.medianDeviation(UserStatics.data);
        }
        
    }
    private function resetDisplay()
    {
        meanDisplay.htmlText = "";
        //modeDisplay.htmlText = "";
        //daGraph.visible = false;
    }
}