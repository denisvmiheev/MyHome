#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ЗаполнитьРеквизитыСумм();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Документы.РегистрацияДоходов.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);

	Документы.РегистрацияДоходов.ОтразитьДвиженияДенежныхСредств(ЭтотОбъект, Отказ);
	Документы.РегистрацияДоходов.ОтразитьДвиженияДоходыРасходы(ЭтотОбъект, Отказ);
	Документы.РегистрацияДоходов.ОтразитьДвиженияДоходы(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыСумм()

	ЭтотОбъект.Сумма = Доходы.Итог("Сумма");

КонецПроцедуры

#КонецОбласти

#КонецЕсли