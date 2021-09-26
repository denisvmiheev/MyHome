#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.Доходы.Количество() = 0 Тогда
		НоваяСтрока = Объект.Доходы.Добавить();
		НоваяСтрока.ДатаОперации = ОбщегоНазначения.ТекущаяДатаПользователя();
	КонецЕсли;

	мх_СобытияФорм.ЗаполнитьКэшированныеЗначенияДляСвязиТиповДоходовРасходов(ЭтотОбъект);

	мх_СобытияФорм.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.ДоходыАналитикаДоходовТекущиеДанные,
																		Объект.Доходы[0].СтатьяДоходов,
																		Объект.Доходы[0].АналитикаДоходов);
		
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
	Объект.Доходы[0].АналитикаДоходов = Неопределено;
	ДоходыСтатьяДоходовТекущиеДанныеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДоходыСтатьяДоходовТекущиеДанныеПриИзмененииНаСервере()
	мх_СобытияФорм.УстановитьОграничениеТипаДляАналитикиДоходовРасходов(Элементы.ДоходыАналитикаДоходовТекущиеДанные,
																		Объект.Доходы[0].СтатьяДоходов,
																		Объект.Доходы[0].АналитикаДоходов);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыДоходы

&НаКлиенте
Процедура ДоходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	мх_СобытияФормКлиент.ДоходыРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьСтраницыОпераций()

	мх_СобытияФормКлиент.УстановитьВидимостьСтраницыОпераций(ЭтотОбъект, "Доходы");

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
