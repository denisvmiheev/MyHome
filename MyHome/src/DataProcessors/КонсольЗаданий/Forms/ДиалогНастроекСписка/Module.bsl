#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АвтоОбновление = Параметры.АвтоОбновление;
	ПериодАвтоОбновления = Параметры.ПериодАвтоОбновления;
	ИнтервалСекунд = 5;
	Если ПериодАвтоОбновления < ИнтервалСекунд Тогда
		ПериодАвтоОбновления = ИнтервалСекунд;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОК(Команда)
	ИнтервалСекунд = 5;
	Если ПериодАвтоОбновления < ИнтервалСекунд Тогда
		ПериодАвтоОбновления = ИнтервалСекунд;
	КонецЕсли;
	Результат = Новый Структура("АвтоОбновление, ПериодАвтоОбновления", АвтоОбновление, ПериодАвтоОбновления);
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти