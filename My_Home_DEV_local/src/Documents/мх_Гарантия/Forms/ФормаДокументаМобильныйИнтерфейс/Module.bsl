#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТоварыДатаПокупкиПриИзменении(Элемент)

	ДанныеСтроки = Элементы.Товары.ТекущиеДанные;
	ПересчитатьСрокиПоСтроке(ДанныеСтроки, "ДатаПокупки");

КонецПроцедуры

&НаКлиенте
Процедура ТоварыГарантийныйСрокПриИзменении(Элемент)

	ДанныеСтроки = Элементы.Товары.ТекущиеДанные;

	Если ДанныеСтроки.ДатаПокупки > ДанныеСтроки.ГарантийныйСрок Тогда
		ДанныеСтроки.ГарантийныйСрок = Дата(1, 1, 1);
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = '""Гарантийный срок не может быть меньше даты покупки""'"));
		Возврат;
	КонецЕсли;

	ПересчитатьСрокиПоСтроке(ДанныеСтроки, "ГарантийныйСрок");

КонецПроцедуры

&НаКлиенте
Процедура ТоварыГарантияМесПриИзменении(Элемент)

	ДанныеСтроки = Элементы.Товары.ТекущиеДанные;
	ПересчитатьСрокиПоСтроке(ДанныеСтроки, "ГарантияМес");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПересчитатьСрокиПоСтроке(ДанныеСтроки, ЧтоИзменилось)

	ПустаяДата = Дата(1, 1, 1);

	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ДатаПокупки", ПустаяДата);
	СтруктураРезультата.Вставить("ГарантийныйСрок", ПустаяДата);
	СтруктураРезультата.Вставить("ГарантияМес", 0);

	ЗаполнитьЗначенияСвойств(СтруктураРезультата, ДанныеСтроки);

	Если ЧтоИзменилось = "ДатаПокупки" Тогда
		СтруктураРезультата.ГарантийныйСрок = ДобавитьМесяц(СтруктураРезультата.ДатаПокупки, СтруктураРезультата.ГарантияМес);
	ИначеЕсли ЧтоИзменилось = "ГарантийныйСрок" Тогда
		СтруктураРезультата.ГарантияМес = РазностьДатВМесяцах(СтруктураРезультата.ДатаПокупки, СтруктураРезультата.ГарантийныйСрок);
	ИначеЕсли ЧтоИзменилось = "ГарантияМес" Тогда
		СтруктураРезультата.ГарантийныйСрок = ДобавитьМесяц(СтруктураРезультата.ДатаПокупки, СтруктураРезультата.ГарантияМес);
	Иначе
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтруктураРезультата);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазностьДатВМесяцах(ДатаНачала, ДатаОкончания)

	Годы = Год(ДатаОкончания) - Год(ДатаНачала);
	Месяцы = Месяц(ДатаОкончания) - Месяц(ДатаНачала);
	Разность = Месяцы + Годы * 12;
	Возврат Разность;

КонецФункции

#КонецОбласти
