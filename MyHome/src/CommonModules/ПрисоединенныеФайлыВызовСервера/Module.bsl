#Область ПрограммныйИнтерфейс

Функция СоздатьПрисоединенныйФайл(Параметры) Экспорт

	Результат = Новый Структура("Успех, ОписаниеОшибки", Истина, "");
	
	Файл = Новый Файл(Параметры.Имя);
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(Параметры.Хранение);
	ХранилищеЗначения = Новый ХранилищеЗначения(ДанныеФайла);
	
	МетаданныеВладельца = Параметры.ВладелецФайла.Метаданные();
	ИмяПодчиненногоСправочника = МетаданныеВладельца.Имя + "ПрисоединенныеФайлы";
	
	ПрисоединенныйФайлОбъект = Справочники[ИмяПодчиненногоСправочника].СоздатьЭлемент();
	ПрисоединенныйФайлОбъект.ВладелецФайла = Параметры.ВладелецФайла;
	ПрисоединенныйФайлОбъект.ХранилищеФайла = ХранилищеЗначения;
	ЗаполнитьЗначенияСвойств(ПрисоединенныйФайлОбъект, Файл);
	ПрисоединенныйФайлОбъект.Наименование = Файл.ИмяБезРасширения;
	ПрисоединенныйФайлОбъект.Записать();
	
	Возврат Результат;

КонецФункции

Функция ДанныеПрисоединенногоФайла(ПрисоединенныйФайл) Экспорт

	ДанныеФайла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПрисоединенныйФайл, "ХранилищеФайла, ИмяБезРасширения, Расширение");
	
	ДвоичныеДанные = ДанныеФайла.ХранилищеФайла.Получить();
	
	Если ДвоичныеДанные = Неопределено Тогда
		ВызватьИсключение "Данные файла не обнаружены";
	КонецЕсли;
	
	ДанныеФайла.Вставить("ДвоичныеДанные", ДвоичныеДанные);
	ДанныеФайла.Удалить("ХранилищеФайла");
	
	Возврат ДанныеФайла;

КонецФункции

Процедура УдалитьПрисоединенныйФайл(ПрисоединенныйФайл) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
	
	Попытка
		ФайлОбъект.Удалить();	
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти