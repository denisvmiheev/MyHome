#Область ОбработчикиСобытийФормы

// Расписание регламентного задания 
&НаКлиенте
Перем Расписание;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Расписание = ПолучитьРасписаниеРегламентногоЗадания(РегламентноеЗаданиеИД);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого Задание Из Метаданные.РегламентныеЗадания Цикл
		ПредставлениеЗадания = СтрШаблон("%1 (%2)", Задание.Имя, Задание.Синоним);
		Элементы.МетаданныеВыбор.СписокВыбора.Добавить(Задание.Имя, ПредставлениеЗадания);
	КонецЦикла;
	Элементы.МетаданныеВыбор.СписокВыбора.СортироватьПоЗначению();

	Попытка
		ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка при получении списка пользователей информационной базы: " + ОписаниеОшибки();
		Сообщение.Сообщить();
		ПользователиИБ = Неопределено;
	КонецПопытки;

	Если ПользователиИБ <> Неопределено Тогда

		Для Каждого Пользователь Из ПользователиИБ Цикл
			Элементы.ПользователиВыбор.СписокВыбора.Добавить(Пользователь.Имя, Пользователь.ПолноеИмя);
		КонецЦикла;

	КонецЕсли;

	РегламентноеЗаданиеИД = Параметры.ИдентификаторЗадания;
	РегламентноеЗадание = ПолучитьОбъектРегламентногоЗадания(РегламентноеЗаданиеИД);
	Если РегламентноеЗадание <> Неопределено Тогда

		МетаданныеВыбор = РегламентноеЗадание.Метаданные.Имя;

		Метод = РегламентноеЗадание.Метаданные.ИмяМетода;

		Наименование = РегламентноеЗадание.Наименование;
		Ключ = РегламентноеЗадание.Ключ;
		Использование = РегламентноеЗадание.Использование;
		ПользователиВыбор = РегламентноеЗадание.ИмяПользователя;
		КоличествоПовторовПриАварийномЗавершении = РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении;
		ИнтервалПовтораПриАварийномЗавершении = РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении;

		Расписание = РегламентноеЗадание.Расписание;
		
		// Добавлены параметры
		Для Каждого Параметр Из РегламентноеЗадание.Параметры Цикл
			НоваяСтрока = ПараметрыЗадания.Добавить();
			НоваяСтрока.НомерСтроки = ПараметрыЗадания.Индекс(НоваяСтрока) + 1;
			НоваяСтрока.Значение = Параметр;
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(ТипЗнч(Параметр));
			НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		КонецЦикла;

	Иначе
		Расписание = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;

	Элементы.НадписьРасписание.Заголовок = "Выполнять: " + Строка(Расписание);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОК(Команда)
	Если ЗаписатьРегламентноеЗадание(Расписание) Тогда
		ЭтаФорма.Закрыть(РегламентноеЗаданиеИД);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеНажатие(Элемент)
	ИзменитьРасписание();
КонецПроцедуры

&НаКлиенте
Процедура НадписьРасписаниеНажатие(Элемент)
	ИзменитьРасписание();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписание()
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение", ЭтаФорма);
	Диалог.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение(РасписаниеРезультат, ДополнительныеПараметры) Экспорт
	Если РасписаниеРезультат <> Неопределено Тогда
		Расписание = РасписаниеРезультат;
		Элементы.НадписьРасписание.Заголовок = "Выполнять: " + Строка(Расписание);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаданияЗначениеПриИзменении(Элемент)
	ОбновитьПараметры();
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметры()
	Для Каждого ТекСтрока Из ПараметрыЗадания Цикл
		ТекСтрока.НомерСтроки = ПараметрыЗадания.Индекс(ТекСтрока) + 1;
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ТекСтрока.Значение));
		ТекСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьРегламентноеЗадание(Расписание)
	Попытка

		Если МетаданныеВыбор = Неопределено Или МетаданныеВыбор = "" Тогда
			ВызватьИсключение ("Не выбраны метаданные регламентного задания.");
		КонецЕсли;

		РегламентноеЗадание = ПолучитьОбъектРегламентногоЗадания(РегламентноеЗаданиеИД);

		Если РегламентноеЗадание = Неопределено Тогда
			РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеВыбор);
			РегламентноеЗаданиеИД = РегламентноеЗадание.УникальныйИдентификатор;
		КонецЕсли;

		РегламентноеЗадание.Наименование = Наименование;
		РегламентноеЗадание.Ключ = Ключ;
		РегламентноеЗадание.Использование = Использование;
		РегламентноеЗадание.ИмяПользователя = ПользователиВыбор;
		РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении = КоличествоПовторовПриАварийномЗавершении;
		РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении = ИнтервалПовтораПриАварийномЗавершении;
		РегламентноеЗадание.Расписание = Расписание;
		
		// Добавлены параметры регламентного задания
		Если ПараметрыЗадания.Количество() Тогда
			РегламентноеЗадание.Параметры = ПараметрыЗадания.Выгрузить().ВыгрузитьКолонку("Значение");
		Иначе
			РегламентноеЗадание.Параметры = Новый Массив;
		КонецЕсли;

		РегламентноеЗадание.Записать();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка: " + ОписаниеОшибки();
		Сообщение.Сообщить();

		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
КонецФункции

&НаСервере
Функция ПолучитьРасписаниеРегламентногоЗадания(УникальныйНомерЗадания) Экспорт
	ОбъектЗадания = ПолучитьОбъектРегламентногоЗадания(УникальныйНомерЗадания);
	Если ОбъектЗадания = Неопределено Тогда
		Возврат Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;

	Возврат ОбъектЗадания.Расписание;
КонецФункции

&НаКлиенте
Процедура МетаданныеВыборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СвойстваЗадания = ПолучитьСвойстваЗадания(ВыбранноеЗначение);
	Наименование = СвойстваЗадания.Представление;
	Метод = СвойстваЗадания.ИмяМетода;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСвойстваЗадания(ИмяМетаданных)
	Результат = Новый Структура("ИмяМетода, Представление");
	МетаданныеЗадания = Метаданные.РегламентныеЗадания.Найти(ИмяМетаданных);
	Если МетаданныеЗадания <> Неопределено Тогда
		Результат.ИмяМетода = МетаданныеЗадания.ИмяМетода;
		Результат.Представление = МетаданныеЗадания.Представление();
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Функция ПолучитьОбъектРегламентногоЗадания(УникальныйНомерЗадания) Экспорт

	Попытка

		Если Не ПустаяСтрока(УникальныйНомерЗадания) Тогда
			УникальныйИдентификаторЗадания = Новый УникальныйИдентификатор(УникальныйНомерЗадания);
			ТекущееРегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УникальныйИдентификаторЗадания);
		Иначе
			ТекущееРегламентноеЗадание = Неопределено;
		КонецЕсли;

	Исключение
		ТекущееРегламентноеЗадание = Неопределено;
	КонецПопытки;

	Возврат ТекущееРегламентноеЗадание;

КонецФункции

#КонецОбласти