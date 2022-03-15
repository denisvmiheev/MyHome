									   
#Область ПрограммныйИнтерфейс    

Функция БазовыйАдресРесурсаАпи() Экспорт   
	
	Возврат мх_ИнтеграцияТинькоффВызовСервера.БазовыйАдресРесурсаАпи();
	
КонецФункции      

Функция ПостфиксБазовогоАдресаРесурсаАпи() Экспорт
	
	Возврат "origin=web%2Cib5%2Cplatform";
	
КонецФункции

Функция ТелоЗапросаАвторизацииПослеВводаПароля(ИдентификаторСессии, Пароль) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("wuid", ИдентификаторСессии);
	//entrypoint_type=context
	//fingerprint=Mozilla%2F5.0+%28Windows+NT+10.0+Win64+x64%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Chrome%2F95.0.4638.69+Safari%2F537.36+Edg%2F95.0.1020.44%23%23%232560x1440x24%23%23%23-180%23%23%23true%23%23%23true%23%23%23PDF+Viewer%3A%3APortable+Document+Format%3A%3Aapplication%2Fpdf%7Epdf%2Ctext%2Fpdf%7Epdf%3BChrome+PDF+Viewer%3A%3APortable+Document+Format%3A%3Aapplication%2Fpdf%7Epdf%2Ctext%2Fpdf%7Epdf%3BChromium+PDF+Viewer%3A%3APortable+Document+Format%3A%3Aapplication%2Fpdf%7Epdf%2Ctext%2Fpdf%7Epdf%3BMicrosoft+Edge+PDF+Viewer%3A%3APortable+Document+Format%3A%3Aapplication%2Fpdf%7Epdf%2Ctext%2Fpdf%7Epdf%3BWebKit+built-in+PDF%3A%3APortable+Document+Format%3A%3Aapplication%2Fpdf%7Epdf%2Ctext%2Fpdf%7Epdf
	//fingerprint_gpu_shading_language_version=WebGL+GLSL+ES+1.0+%28OpenGL+ES+GLSL+ES+1.0+Chromium%29
	//fingerprint_gpu_vendor=WebKit
	//fingerprint_gpu_extensions_hash=c3b6eeedec3a1cf8f65e78aa06c6ea79
	//fingerprint_gpu_extensions_count=33
	Параметры.Вставить("fingerprint_device_platform", "Win32");
	Параметры.Вставить("fingerprint_client_timezone", "-180");
	Параметры.Вставить("fingerprint_client_language", "ru");
	//fingerprint_canvas=472f0f7ea04ec61418b0c20625a430af
	Параметры.Вставить("fingerprint_accept_language", "ru");
	//mid=55797745855269727884095421356824269869
	Параметры.Вставить("device_type", "desktop");
	Параметры.Вставить("form_view_mode", "desktop");
	Параметры.Вставить("password", Пароль);  
	
	ТелоЗапроса = мх_ИнтеграцияТинькоффКлиентСервер.СформироватьСтрокуПараметров(Параметры);
	
	Возврат ТелоЗапроса;	
	
КонецФункции

#КонецОбласти									   