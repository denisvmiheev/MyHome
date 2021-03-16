#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.Доходы.Количество() = 0 Тогда
		НоваяСтрока = Объект.Доходы.Добавить();
		НоваяСтрока.ДатаОперации = ТекущаяДата();
	КонецЕсли;

	СобытияФорм.ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(ЭтотОбъект);

	СобытияФормВызовСервера.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.ДоходыАналитикаДоходовТекущиеДанные,
		Объект.Доходы[0].СтатьяДоходов);
		
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

	НесколькоОпераций = Объект.Доходы.Количество() > 1;
	УстановитьВидимостьСтраницыОпераций();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НесколькоОперацийПриИзменении(Элемент)
	УстановитьВидимостьСтраницыОпераций();
КонецПроцедуры

&НаКлиенте
Процедура ДоходыСтатьяДоходовТекущиеДанныеПриИзменении(Элемент)
	ДоходыСтатьяДоходовТекущиеДанныеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДоходыСтатьяДоходовТекущиеДанныеПриИзмененииНаСервере()
	СобытияФормВызовСервера.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.ДоходыАналитикаДоходовТекущиеДанные,
		Объект.Доходы[0].СтатьяДоходов);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыДоходы

&НаКлиенте
Процедура ДоходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	СобытияФормКлиент.ДоходыРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование);
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
