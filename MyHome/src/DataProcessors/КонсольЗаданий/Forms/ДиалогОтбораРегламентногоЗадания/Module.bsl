#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Предопределенное = Ложь;
	Использование = Ложь;

	Для Каждого Метаданное Из Метаданные.РегламентныеЗадания Цикл
		Элементы.МетаданныеВыбор.СписокВыбора.Добавить(Метаданное.Имя, Метаданное.Представление());
	КонецЦикла;

	Если Параметры.Отбор <> Неопределено Тогда
		Для Каждого Свойство Из Параметры.Отбор Цикл
			Если Свойство.Ключ = "Ключ" Тогда
				Ключ = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Наименование" Тогда
				Наименование = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Использование" Тогда
				Использование = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Предопределенное" Тогда
				Предопределенное = Свойство.Значение;
			ИначеЕсли Свойство.Ключ = "Метаданные" Тогда
				МетаданныеВыбор = Свойство.Значение;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОК(Команда)
	Отбор = Новый Структура;

	Если Не ПустаяСтрока(Ключ) Тогда
		Отбор.Вставить("Ключ", Ключ);
	КонецЕсли;

	Если Не ПустаяСтрока(Наименование) Тогда
		Отбор.Вставить("Наименование", Наименование);
	КонецЕсли;

	Если МетаданныеВыбор <> "" Тогда
		Отбор.Вставить("Метаданные", МетаданныеВыбор);
	КонецЕсли;

	Если Предопределенное Тогда
		Отбор.Вставить("Предопределенное", Предопределенное);
	КонецЕсли;

	Если Использование Тогда
		Отбор.Вставить("Использование", Использование);
	КонецЕсли;

	Закрыть(Отбор);
КонецПроцедуры

#КонецОбласти