Функция УстановитьНастройкиОтчета(ВидОтчета, ПараметрыОтчета = Неопределено, Отборы = Неопределено) Экспорт
	ОтчетОбъект = Отчеты[ВидОтчета].Создать();

	КомпоновщикНастроек          = ОтчетОбъект.КомпоновщикНастроек;
	Настройки                               = КомпоновщикНастроек.Настройки;
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;

	Если ПараметрыОтчета <> Неопределено Тогда
		Для Каждого ЭлПараметр Из ПараметрыОтчета Цикл

			ЭлементНастройки = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ЭлПараметр.Ключ));
			ЭлементНастройки.Значение = ЭлПараметр.Значение;
			Если ЗначениеЗаполнено(ЭлементНастройки.ИдентификаторПользовательскойНастройки) Тогда
				ПользовательскийПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
					ЭлементНастройки.ИдентификаторПользовательскойНастройки);
				Если ТипЗнч(ПользовательскийПараметр) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
					ПользовательскийПараметр.Значение = ЭлементНастройки.Значение;
					ПользовательскийПараметр.Использование = Истина;
				КонецЕсли;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Если Отборы <> Неопределено Тогда

		Для Каждого ЭлОтбор Из Отборы Цикл

			текОтбор = Новый ПолеКомпоновкиДанных(ЭлОтбор.Ключ);
			Для Каждого ЭлементНастройки Из Настройки.Отбор.Элементы Цикл
				Если ЭлементНастройки.ЛевоеЗначение = текОтбор Тогда
					ЭлементНастройки.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
					ЭлементНастройки.ПравоеЗначение = ЭлОтбор.Значение;
					ЭлементНастройки.Использование = Истина;
					Если ЗначениеЗаполнено(ЭлементНастройки.ИдентификаторПользовательскойНастройки) Тогда
						ПользовательскийПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
							ЭлементНастройки.ИдентификаторПользовательскойНастройки);
						Если ТипЗнч(ПользовательскийПараметр) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
							ПользовательскийПараметр.ВидСравнения   = ЭлементНастройки.ВидСравнения;
							ПользовательскийПараметр.ПравоеЗначение = ЭлементНастройки.ПравоеЗначение;
							ПользовательскийПараметр.Использование  = ЭлементНастройки.Использование;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;

		КонецЦикла;

	КонецЕсли;

	Возврат ПользовательскиеНастройки;

КонецФункции