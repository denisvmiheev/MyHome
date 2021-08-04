#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиОбъекта

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;

	мх_ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	мх_ОбработчикиСобытийДокументов.ЗаполнитьРеквизитыШапкиПоДаннымТабличнойЧасти(ЭтотОбъект,
		"Расходы",
		"Кошелек, СтатьяРасходов, АналитикаРасходов, ДатаОперации, ВнеБюджета",
		"Сумма");
	
	ЗаполнитьРеквизитыСумм();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Документы.мх_РегистрацияРасходов.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);

	Документы.мх_РегистрацияРасходов.ОтразитьДвиженияДенежныхСредств(ЭтотОбъект, Отказ);
	Документы.мх_РегистрацияРасходов.ОтразитьДвиженияДоходыРасходы(ЭтотОбъект, Отказ);
	Документы.мх_РегистрацияРасходов.ОтразитьДвиженияРасходы(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыСумм()

	ЭтотОбъект.Сумма = Расходы.Итог("Сумма");

КонецПроцедуры

#КонецОбласти

#КонецЕсли