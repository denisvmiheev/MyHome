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
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	Если ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		РаботаСФайламиСлужебный.ИзменитьФормуДляВнешнегоПользователя(ЭтотОбъект, Истина);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", ТекущийПользователь);
	
	РаботаСФайламиСлужебный.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	РаботаСФайламиСлужебный.ДобавитьОтборыВСписокФайлов(Список);
	Элементы.ПоказыватьСлужебныеФайлы.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
	ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере();
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПапкиФайлов" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_Файл" Тогда
		Элементы.Список.Обновить();
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Файл") Тогда
			Элементы.Список.ТекущаяСтрока = Параметр.Файл;
		ИначеЕсли Источник <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Источник;
		КонецЕсли;
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант")
	   И (ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
		  Или ВРег(Источник) = ВРег("ИспользоватьШифрование")) Тогда
		ПодключитьОбработчикОжидания("ПриИзмененииИспользованияПодписанияИлиШифрования", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Элементы.Список.ТекущиеДанные.Ссылка, , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьЗавершение", ЭтотОбъект);
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОсвобожденияФайла(Обработчик, Элементы.Список.ТекущиеДанные.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.ФайлРедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.Список.Обновить();
	ПодключитьОбработчикОжидания("УстановитьДоступностьФайловыхКоманд", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	УстановитьСнятьПометкуУдаления(Элементы.Список.ВыделенныеСтроки);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УстановитьСнятьПометкуУдаления(Элементы.Список.ВыделенныеСтроки);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСлужебныеФайлы(Команда)
	
	Элементы.ПоказыватьСлужебныеФайлы.Пометка = 
		РаботаСФайламиСлужебныйКлиент.ПоказыватьСлужебныеФайлыНажатие(Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.УдалитьДанные(
		Новый ОписаниеОповещения("ПослеУдаленияДанных", ЭтотОбъект),
		Элементы.Список.ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПомеченныеФайлы(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ИзменитьОтборПоПометкеУдаления(Список.Отбор, Элементы.ПоказыватьПомеченныеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОсвободитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка.
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущиеДанные.Ссылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И ТипЗнч(ТекущиеДанные.Ссылка) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		УстановитьДоступностьКоманд(ТекущиеДанные.РедактируетТекущийПользователь,
			ТекущиеДанные.Редактирует, ТекущиеДанные.Автор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСнятьПометкуУдаления(Знач ВыделенныеСтроки)
	
	Если ТипЗнч(ВыделенныеСтроки) = Тип("Массив") Тогда
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Файл = ВыделеннаяСтрока.Файл.ПолучитьОбъект();
			Файл.УстановитьПометкуУдаления(НЕ Файл.ПометкаУдаления);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует, Автор)
	
	Элементы.ФормаОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	
	АвторТекущийПользователь =
		Элементы.Список.ТекущиеДанные.Автор = ПользователиКлиент.АвторизованныйПользователь();
	Элементы.ФормаУдалить.Доступность = АвторТекущийПользователь;
	Элементы.СписокКонтекстноеМенюУдалить.Доступность = АвторТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияПодписанияИлиШифрования()
	
	ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере()
	
	РаботаСФайламиСлужебный.КриптографияПриСозданииФормыНаСервере(ЭтотОбъект,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
