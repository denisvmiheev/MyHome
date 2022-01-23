#Область ПрограммныйИнтерфейс

// Проверяет наличие выделенной строки, необходимой для выполнения команды. Выводит сообщение в случае ее отсутствия.
//
// Параметры:
//  ТаблицаФормы - ТаблицаФормы - элемент формы, содержащий табличную часть.
//
// Возвращаемое значение:
//  Булево - Истина - выполнение команды возможно; Ложь - в противном случае.
//
Функция ВыбранаСтрокаДляВыполненияКоманды(ТаблицаФормы) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаФормы.ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для выполнения команды требуется выбрать строку табличной части.'"));
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#Область РазбиениеСтроки

// Функция-конструктор дополнительных параметров разбиения строки.
//
// Возвращаемое значение:
//  Структура:
//     * ИмяПоляКоличество - Строка - имя поля, по которому будет происходить разбиение
//     * Заголовок - Строка - заголовок формы ввода числа
//     * РазрешитьНулевоеКоличество - Булево - признак, что в исходной и конечной строке может быть 0
//     * Количество - Неопределено, Число - количество, которое будет отображено в форме редактирования числа;
//          если Неопределенно - будет показано количество, взятое из исходной строки.
//
Функция ПараметрыРазбиенияСтроки() Экспорт
	
	ПараметрыРазбиенияСтроки = Новый Структура;
	ПараметрыРазбиенияСтроки.Вставить("ИмяПоляКоличество", "Сумма");
	ПараметрыРазбиенияСтроки.Вставить("Заголовок", НСтр("ru = 'Введите сумму в новой строке'"));
	ПараметрыРазбиенияСтроки.Вставить("РазрешитьНулевоеКоличество", Ложь);
	ПараметрыРазбиенияСтроки.Вставить("Количество", Неопределено);
	ПараметрыРазбиенияСтроки.Вставить("ПредупреждениеОЗапретеНулевогоКоличества",
										НСтр("ru = 'Невозможно разбить строку с нулевой суммой.'"));
	
	Возврат ПараметрыРазбиенияСтроки;
	
КонецФункции

// Разбивает выделенную строку на две по введенному количеству.
//
// Параметры:
//  ТабличнаяЧасть - ДанныеФормыКоллекция - табличная часть, в которой необходимо разбить выделенную строку
//  ТаблицаФормы - ТаблицаФормы - элемент формы, содержащий табличную часть
//  ОповещениеПослеРазбиения - ОписаниеОповещения - описание процедуры, вызов которой будет произведен после разбиения,
//      с передачей значения результата разбиения: ДанныеФормыЭлементКоллекции - новая строка полученная разбиением;
//      Неопределено - разбиение не проводилось.
//  ПараметрыРазбиенияСтроки - Структура - (см. функцию РаботаСТабличнымиЧастямиКлиент.ПараметрыРазбиенияСтроки).
//
Процедура РазбитьСтроку(ТабличнаяЧасть, ТаблицаФормы, ОповещениеПослеРазбиения = Неопределено, ПараметрыРазбиенияСтроки = Неопределено) Экспорт
	
	Если ПараметрыРазбиенияСтроки = Неопределено Тогда
		ПараметрыРазбиенияСтроки = ПараметрыРазбиенияСтроки();
	КонецЕсли;
	
	Отказ = Ложь;
	Если Не ВыбранаСтрокаДляВыполненияКоманды(ТаблицаФормы) Тогда
		Отказ = Истина;
	ИначеЕсли ТаблицаФормы.ТекущиеДанные[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] = 0
		И Не ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество Тогда
		ПоказатьПредупреждение(, ПараметрыРазбиенияСтроки.ПредупреждениеОЗапретеНулевогоКоличества);
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ТаблицаФормы.ТекущиеДанные[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] = 0 Тогда // копирование строки
		ДобавитьСтрокуРазбиением(ТабличнаяЧасть, ТаблицаФормы, 0, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
	Иначе
		ПараметрыОбработки = Новый Структура;
		ПараметрыОбработки.Вставить("ТабличнаяЧасть",           ТабличнаяЧасть);
		ПараметрыОбработки.Вставить("ЭлементФормы",             ТаблицаФормы);
		ПараметрыОбработки.Вставить("ОповещениеПослеРазбиения", ОповещениеПослеРазбиения);
		ПараметрыОбработки.Вставить("ПараметрыРазбиенияСтроки", ПараметрыРазбиенияСтроки);
		
		ВвестиКоличествоДляРазбиения(ПараметрыОбработки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтрокуРазбиением(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки)
	
	ТекущаяСтрока = ЭлементФормы.ТекущиеДанные;
	НоваяСтрока   = ТЧ.Вставить(ТЧ.Индекс(ТекущаяСтрока) + 1);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	
	НоваяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество]   = Количество;
	ТекущаяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] =
		ТекущаяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] - Количество;
	
	Если ОповещениеПослеРазбиения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, НоваяСтрока);
	КонецЕсли;
	
	ЭлементФормы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

Процедура ВвестиКоличествоДляРазбиения(ПараметрыОбработки) Экспорт
	
	ПараметрыРазбиенияСтроки = ПараметрыОбработки.ПараметрыРазбиенияСтроки;
	
	Если ПараметрыРазбиенияСтроки.Количество = Неопределено Тогда
		Количество = ПараметрыОбработки.ЭлементФормы.ТекущиеДанные[ПараметрыРазбиенияСтроки.ИмяПоляКоличество];
	Иначе
		Количество = ПараметрыРазбиенияСтроки.Количество;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВвестиКоличествоДляРазбиенияПослеВвода", ЭтотОбъект, ПараметрыОбработки);
	ПоказатьВводЧисла(Оповещение, Количество, ПараметрыРазбиенияСтроки.Заголовок, 15, 3);
	
КонецПроцедуры

Процедура ВвестиКоличествоДляРазбиенияПослеВвода(Количество, ПараметрыОбработки) Экспорт
	
	ОповещениеПослеРазбиения = ПараметрыОбработки.ОповещениеПослеРазбиения;
	
	Если Количество = Неопределено Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыРазбиенияСтроки = ПараметрыОбработки.ПараметрыРазбиенияСтроки;
	ТекущееКоличество = ПараметрыОбработки.ЭлементФормы.ТекущиеДанные[ПараметрыРазбиенияСтроки.ИмяПоляКоличество];
	
	ТекстСообщения = Неопределено;
	Если Количество = 0 И Не ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть равно нулю.'");
	ИначеЕсли Количество = ТекущееКоличество И Не ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке должно отличаться от количества в текущей.'");
	ИначеЕсли Количество < 0 И ТекущееКоличество >= 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть отрицательным.'");
	ИначеЕсли Количество > 0 И ТекущееКоличество <= 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть положительным.'");
	ИначеЕсли Количество > ТекущееКоличество И ТекущееКоличество >= 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть больше количества в текущей.'");
	ИначеЕсли Количество < ТекущееКоличество И ТекущееКоличество <= 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть меньше количества в текущей.'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		Оповещение = Новый ОписаниеОповещения("ВвестиКоличествоДляРазбиения", ЭтотОбъект, ПараметрыОбработки);
		ПоказатьПредупреждение(Оповещение, ТекстСообщения);
	Иначе
		ДобавитьСтрокуРазбиением(ПараметрыОбработки.ТабличнаяЧасть, ПараметрыОбработки.ЭлементФормы,
			Количество, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти