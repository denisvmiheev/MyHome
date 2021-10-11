#Область ПрограммныйИнтерфейс

Процедура ДоходыРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование) Экспорт
	
	ЗаполнитьДатуОперации(Элемент, НоваяСтрока, Копирование);	
	
КонецПроцедуры

Процедура АналитикаПриИзменении(Элемент, Аналитика = Неопределено) Экспорт
	
	Если Аналитика = Неопределено Тогда
		Подсказка = ""
	Иначе
		Подсказка = ТипЗнч(Аналитика);
	КонецЕсли;
	
	Элемент.ПодсказкаВвода = Строка(Подсказка);
	
КонецПроцедуры

Процедура УстановитьВидимостьСтраницыОпераций(Форма,
									 ИмяТаблицыОпераций,
									 ИмяЭлементаСтраницы = "ГруппаСтраницы",
									 ИмяСтраницыНесколькоОпераций = "СтраницаНесколькоОпераций",
									 ИмяСтраницыОднаОперация = "СтраницаОднаОперация") Экспорт
									 
	Объект = Форма.Объект;
	НесколькоОпераций = Форма.НесколькоОпераций;
	КоличествоОпераций = Объект[ИмяТаблицыОпераций].Количество();
	
	Страницы = Форма.Элементы[ИмяЭлементаСтраницы];
	СтраницаНесколькоОпераций = Форма.Элементы[ИмяСтраницыНесколькоОпераций];
	СтраницаОднаОперация = Форма.Элементы[ИмяСтраницыОднаОперация];
	
	Если КоличествоОпераций > 1 
		И Страницы.ТекущаяСтраница = СтраницаНесколькоОпераций
		И НЕ НесколькоОпераций Тогда
		
		Форма.НесколькоОпераций = Истина;	
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Необходимо оставить только одну строку в таблице операций'"));
		Возврат;
	
	КонецЕсли;
	
	Если НесколькоОпераций Тогда
		Страницы.ТекущаяСтраница = СтраницаНесколькоОпераций;
	Иначе
		Страницы.ТекущаяСтраница = СтраницаОднаОперация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДатуОперации(Элемент, НоваяСтрока, Копирование)
	
	Если НЕ НоваяСтрока ИЛИ Копирование Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ Элемент.ТекущиеДанные.Свойство("ДатаОперации") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаОперации) Тогда
		Элемент.ТекущиеДанные.ДатаОперации = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти