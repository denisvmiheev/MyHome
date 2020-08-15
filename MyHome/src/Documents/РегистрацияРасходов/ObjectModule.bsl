

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.РегистрацияРасходов.ИнициализироватьТаблицыДляДвижений(ЭтотОбъект);
	
	Документы.РегистрацияРасходов.ОтразитьДвиженияДенежныхСредств(ЭтотОбъект, Отказ);
	Документы.РегистрацияРасходов.ОтразитьДвиженияДоходыРасходы(ЭтотОбъект, Отказ);
	Документы.РегистрацияРасходов.ОтразитьДвиженияРасходы(ЭтотОбъект, Отказ);
	
КонецПроцедуры
