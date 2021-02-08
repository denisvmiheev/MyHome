#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;

	ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Документы.ПеремещениеДенежныхСредств.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);

	Документы.ПеремещениеДенежныхСредств.ОтразитьДвиженияДенежныхСредств(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#КонецЕсли