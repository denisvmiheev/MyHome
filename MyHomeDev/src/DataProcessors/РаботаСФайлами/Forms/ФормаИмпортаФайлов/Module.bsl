///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ПапкаДляДобавления = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ГруппаФайлов = Параметры.ГруппаФайлов;
	ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	ПапкаДляДобавленияСтрокой = ОбщегоНазначения.ПредметСтрокой(ПапкаДляДобавления);
	ХранитьВерсии = РаботаСФайламиСлужебныйВызовСервера.ЭтоСправочникФайлы(ПапкаДляДобавления);
	Элементы.ХранитьВерсии.Видимость = ХранитьВерсии;
	
	Если ТипЗнч(Параметры.МассивИменФайлов) = Тип("Массив") Тогда
		Для Каждого ПутьФайла Из Параметры.МассивИменФайлов Цикл
			ФайлПеренесенный = Новый Файл(ПутьФайла);
			НовыйЭлемент = ВыбранныеФайлы.Добавить();
			НовыйЭлемент.Путь = ПутьФайла;
			НовыйЭлемент.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Обработка.РаботаСФайлами.Форма.ВыборКодировки") Тогда
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеФайлы

&НаКлиенте
Процедура ВыбранныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВыполнить()
	
	ОчиститьСообщения();
	
	ПоляНеЗаполнены = Ложь;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Нет файлов для добавления.'"), , "ВыбранныеФайлы");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПоляНеЗаполнены = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлыСписокЗначений = Новый СписокЗначений;
	Для Каждого СтрокаСписка Из ВыбранныеФайлы Цикл
		ВыбранныеФайлыСписокЗначений.Добавить(СтрокаСписка.Путь);
	КонецЦикла;
	
#Если ВебКлиент Тогда
	
	МассивОпераций = Новый Массив;
	
	Для Каждого СтрокаСписка Из ВыбранныеФайлы Цикл
		ОписаниеВызова = Новый Массив;
		ОписаниеВызова.Добавить("ПоместитьФайлы");
		
		ПомещаемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(СтрокаСписка.Путь, "");
		ПомещаемыеФайлы.Добавить(Описание);
		ОписаниеВызова.Добавить(ПомещаемыеФайлы);
		
		ОписаниеВызова.Добавить(Неопределено); // не используется
		ОписаниеВызова.Добавить(Неопределено); // не используется
		ОписаниеВызова.Добавить(Ложь);         // Интерактивно = Ложь
		
		МассивОпераций.Добавить(ОписаниеВызова);
	КонецЦикла;
	
	Если НЕ ЗапроситьРазрешениеПользователя(МассивОпераций) Тогда
		// Пользователь не дал разрешения.
		Закрыть();
		Возврат;
	КонецЕсли;	
#КонецЕсли	
	
	ДобавленныеФайлы = Новый Массив;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДобавленныеФайлы", ДобавленныеФайлы);
	Обработчик = Новый ОписаниеОповещения("ДобавитьВыполнитьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	ПараметрыВыполнения = РаботаСФайламиСлужебныйКлиент.ПараметрыИмпортаФайлов();
	ПараметрыВыполнения.ОбработчикРезультата          = Обработчик;
	ПараметрыВыполнения.Владелец                      = ПапкаДляДобавления;
	ПараметрыВыполнения.ВыбранныеФайлы                = ВыбранныеФайлыСписокЗначений; 
	ПараметрыВыполнения.Комментарий                   = Комментарий;
	ПараметрыВыполнения.ХранитьВерсии                 = ХранитьВерсии;
	ПараметрыВыполнения.УдалятьФайлыПослеДобавления   = УдалятьФайлыПослеДобавления;
	ПараметрыВыполнения.Рекурсивно                    = Ложь;
	ПараметрыВыполнения.ИдентификаторФормы            = УникальныйИдентификатор;
	ПараметрыВыполнения.ДобавленныеФайлы              = ДобавленныеФайлы;
	ПараметрыВыполнения.Кодировка                     = КодировкаТекстаФайла;
	ПараметрыВыполнения.ГруппаФайлов                  = ГруппаФайлов;
	
	РаботаСФайламиСлужебныйКлиент.ВыполнитьИмпортФайлов(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлыВыполнить()
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьФайлыВыполнитьПослеУстановкиРасширения", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыполнитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Закрыть();
	
	Источник = Неопределено;
	КоличествоДобавленныхФайлов = Результат.ДобавленныеФайлы.Количество();
	Если КоличествоДобавленныхФайлов > 0 Тогда
		Источник = Результат.ДобавленныеФайлы[КоличествоДобавленныхФайлов - 1].ФайлСсылка;
	КонецЕсли;
	Оповестить("Запись_Файл", Новый Структура("ЭтоНовый", Истина), Источник);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлыВыполнитьПослеУстановкиРасширения(РасширениеУстановлено, ПараметрыВыполнения) Экспорт
	Если Не РасширениеУстановлено Тогда
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы (*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ВыбранныеФайлы.Очистить();
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			ФайлПеренесенный = Новый Файл(ИмяФайла);
			НовыйЭлемент = ВыбранныеФайлы.Добавить();
			НовыйЭлемент.Путь = ИмяФайла;
			НовыйЭлемент.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
