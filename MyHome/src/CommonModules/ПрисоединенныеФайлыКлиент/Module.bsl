
#Область ПрограммныйИнтерфейс

Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл) Экспорт

	ДанныеФайла = ПрисоединенныеФайлыВызовСервера.ДанныеПрисоединенногоФайла(ПрисоединенныйФайл);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение);
	
	ПолноеИмяВременногоФайла = КаталогВременныхФайлов() + ИмяВременногоФайла;
	
	ДвоичныеДанные = ДанныеФайла.ДвоичныеДанные;
	
	ДвоичныеДанные.Записать(ПолноеИмяВременногоФайла);
	
	ЗапуститьПриложение(ПолноеИмяВременногоФайла);

КонецПроцедуры

#КонецОбласти