
#Область ОбработчикиСобытий

&НаСервере
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;

	мх_ОбработчикиСобытий.ЗаполнитьТипАналитикиПоУмолчанию(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти