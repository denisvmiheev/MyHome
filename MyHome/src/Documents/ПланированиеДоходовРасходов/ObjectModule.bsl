
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПланированиеДоходовРасходов.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);
	
	Документы.ПланированиеДоходовРасходов.ОтразитьДвиженияДоходыРасходы(ЭтотОбъект, Отказ);
	Документы.ПланированиеДоходовРасходов.ОтразитьДвиженияДоходы(ЭтотОбъект, Отказ);
	Документы.ПланированиеДоходовРасходов.ОтразитьДвиженияРасходы(ЭтотОбъект, Отказ);
	
КонецПроцедуры





