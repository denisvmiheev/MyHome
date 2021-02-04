#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗаполнитьСписокРолей();

	ЗаполнитьДанныеПользователя();

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ПараметрыПользователя = ПользователиКлиентСервер.НовыеПараметрыПользователяИнформационнойБазы(Объект, СписокРолей);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПараметрыПользователя", ПараметрыПользователя);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПустаяСтрока(Объект.Код) Тогда
		Объект.Код = Объект.Наименование;
	КонецЕсли;

	ПроверитьЗаполнениеДанныхПользователя(Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьЗаполнениеДанныхПользователя(Отказ)

	ЕстьРоли = Ложь;
	Для Каждого Роль Из СписокРолей Цикл

		Если Роль.Пометка Тогда
			ЕстьРоли = Истина;
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Если Не ЕстьРоли Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Пользователю не указано ни одной роли", , , , Отказ);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРолей()

	Для Каждого Роль Из Метаданные.Роли Цикл
		СписокРолей.Добавить(Роль.Имя, Роль.Синоним);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОтметитьРолиТекущегоПользователя(РолиПользователяИБ)

	Для Каждого РольПользователя Из РолиПользователяИБ Цикл
		НайденнаяРоль = СписокРолей.НайтиПоЗначению(РольПользователя.Имя);
		Если НайденнаяРоль <> Неопределено Тогда
			НайденнаяРоль.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПользователя()

	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;

	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Объект.ИдентификаторПользователяИБ);

	Если ПользовательИБ = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ОтметитьРолиТекущегоПользователя(ПользовательИБ.Роли);

	Объект.Код			 = ПользовательИБ.Имя;
	Объект.Наименование	 = ПользовательИБ.ПолноеИмя;

	ЗаполнитьЗначенияСвойств(Объект, ПользовательИБ);

КонецПроцедуры

#КонецОбласти