#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.Расходы.Количество() = 0 Тогда
		НоваяСтрока = Объект.Расходы.Добавить();
		НоваяСтрока.ДатаОперации = ТекущаяДата();
	КонецЕсли;

	мх_СобытияФорм.ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(ЭтотОбъект);

	мх_СобытияФорм.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.РасходыАналитикаРасходовТекущиеДанные,
																		Объект.Расходы[0].СтатьяРасходов,
																		Объект.Расходы[0].АналитикаРасходов);
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	НесколькоОпераций = Объект.Расходы.Количество() > 1;
	УстановитьВидимостьСтраницыОпераций();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НесколькоОперацийПриИзменении(Элемент)
	УстановитьВидимостьСтраницыОпераций();
КонецПроцедуры

&НаКлиенте
Процедура РасходыСтатьяРасходовТекущиеДанныеПриИзменении(Элемент)
	РасходыСтатьяРасходовТекущиеДанныеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура РасходыСтатьяРасходовТекущиеДанныеПриИзмененииНаСервере()
	мх_СобытияФорм.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.РасходыАналитикаРасходовТекущиеДанные,
																		Объект.Расходы[0].СтатьяРасходов,
																		Объект.Расходы[0].АналитикаРасходов);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыРасходы

&НаКлиенте
Процедура РасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	мх_СобытияФормКлиент.ДоходыРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьСтраницыОпераций()

	Если НесколькоОпераций Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаНесколькоОпераций;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОднаОперация;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ОчиститьСообщения();
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры


// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти