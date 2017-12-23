/* Подключение заголовочных файлов с описанимями базовых функций windows и Direct3D */
#include <windows.h>
#include <windowsx.h>
#include <d3d9.h>
#include <d3dx9.h>
#include <d3dx9shape.h>

/* Разрешение окна по ширине и высоте */
#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 600
/* Подключение библиотеки Direct3D */
#pragma comment (lib, "d3d9.lib")
#pragma comment (lib, "d3dx9.lib")

/* Глобальные объявления */
LPDIRECT3D9 d3d;    // Указатель на COM интерфейс Direct3D
LPDIRECT3DDEVICE9 d3ddev;    // Указатель на класс устройства
LPDIRECT3DVERTEXBUFFER9 v_buffer = NULL;    // the pointer to the vertex buffer
LPDIRECT3DTEXTURE9 saturnTexture; // Указатель на текстуру Сатурна
LPDIRECT3DTEXTURE9 titanTexture; // Указатель на текстуру Титана
LPDIRECT3DTEXTURE9 ringsTexture; // Указатель на текстуру Колец
LPDIRECT3DTEXTURE9 skyTexture; // Указатель на текстуру космоса

bool light = TRUE; // Состояние освещения
LPD3DXMESH titan; // Модель Титана
LPD3DXMESH sky; // Модель сферы для окружения
LPD3DXMESH saturn; // Модель Сатурна
bool mouse = false; // Состояние левой кнопки мыши
int ox = 0; // Прошлое значение координаты курсора по оси X
int oy = 0; // Прошлое значение координаты курсора по оси Y

D3DXMATRIX matTranslate;  // Матрица параллельного переноса
D3DXMATRIX matRotateX;    // Матрица поворота по оси X
D3DXMATRIX matRotateY;    // Матрица поворота по оси Y
float rotation = 0.0f;    // Угол вращения планеты в радианах
float lookRotX = 0.0f;    // Угол поворота взгляда в радианах по оси X
float lookRotY = 0.0f;    // Угол поворота взгляда в радианах по оси Y
float lookDX = 0.0f;      // Дельта изменения угла взгляда по оси X
float lookDY = 0.0f;      // Дельта изменения угла взгляда по оси Y
float lookSwX = 0.0f;     // Угол поворота точки обзора в радианах по оси X
float lookSwY = 0.0f;     // Угол поворота точки обзора в радианах по оси Y
float lookDsX = 0.0f;     // Дельта изменения точки обзора по оси X
float lookDsY = 0.0f;     // Дельта изменения точки обзора по оси Y

/* Прототипы функций */
void initD3D(HWND hWnd);    /* Функция настроийки и инициализации Direct3D */
void render_frame(void);    /* Функция отображения одного кадра */
void cleanD3D(void);        /* Функция закрытия Direct3D и освобождения памяти */
void init_graphics(void);   /* Функция инициализации графических объектов */
void viewTransform();       /* Трансформация матрицы представления и проекции */
void drawSky();             /* Функция отображения заднего фона */
void drawRing();            /* Функция отображения колец */
void drawTitan();           /* Функция отображения Титана */
void drawSaturn();          /* Функция отображения Сатурна */
void setTexture(LPDIRECT3DTEXTURE9 texture); /* Функция установки текстуры */
void init_light(void);      /* Функция инициализации освещения и материала */

/* Функция создания модели сферы с текстурными координатами  */
LPD3DXMESH CreateMappedSphere(LPDIRECT3DDEVICE9 pDev,float fRad,UINT slices,UINT stacks);

/* Структура формата вершин */
struct CUSTOMVERTEX {FLOAT X, Y, Z; FLOAT nx, ny, nz; FLOAT tu, tv; DWORD COLOR; };
#define CUSTOMFVF (D3DFVF_XYZ | D3DFVF_NORMAL | D3DFVF_TEX1 | D3DFVF_DIFFUSE )

/* Структура формата вершин для сферы с текстурными координатами */
typedef struct {
    D3DXVECTOR3 pos;     // Вектор позиции вершины
    D3DXVECTOR3 norm;    // Вектон нормали вершины
    float tu; float tv;  // Текстурные координаты
} *LPVERTEX;
#define FVF_VERTEX    D3DFVF_XYZ|D3DFVF_NORMAL|D3DFVF_TEX1

/* Прототип функции обработчика оконных сообщений */
LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);


/* Входная точка для программ Windows */
int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow) {
    HWND hWnd; // Главное окно
    WNDCLASSEX wc; // Структура класса окна

    ZeroMemory(&wc, sizeof(WNDCLASSEX)); // Инициализация структуры нулями

    /* Установка параметров класса окна */
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WindowProc; // Назначение обработчика сообщений
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)COLOR_WINDOW;
    wc.lpszClassName = "WindowClass";

    RegisterClassEx(&wc); // Реристрация класса окна
    /* Создание главного окна приложения по зарегестрированному классу */
    hWnd = CreateWindowEx(0, "WindowClass", "Our First Direct3D Program",
                          WS_OVERLAPPEDWINDOW,
                          300, 300,
                          800, 600,
                          NULL, NULL, hInstance, NULL);

    // Отображение окна
    ShowWindow(hWnd, nCmdShow);
    initD3D(hWnd);

    MSG msg; // Сообщение
    // Главный цикл обработки сообщений и отрисовки
    while(TRUE) {
        /* Стандартный конвейр получения и обработки сообщений */
        while(PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }

        // Окончание обработки при получении сообщения завершения работы.
        if(msg.message == WM_QUIT)
            break;

        /* Отображение одного кадра */
        render_frame();
    }

    // Освобождение ресурсов
    cleanD3D();
    return msg.wParam;
}


/* Главный обработчик сообщений */
LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    // Координаты курсора
    int x;
    int y;

    switch(message) {
        case WM_DESTROY: {
                /* Выход при получении сообщения завершения */
                PostQuitMessage(0);
                return 0;
            } break;

        /* Обработка нажатия клавиши */
        case WM_KEYDOWN: {
            switch (wParam) {
                /* Завершение работы при нажатии клавиши Q или Escape */
                case 'Q': 
                case VK_ESCAPE: 
                    PostQuitMessage(0);
                    break;
                /* Включение-выключение освещения */
                case 'L':
                    light = !light;
                    d3ddev->SetRenderState(D3DRS_LIGHTING, light);
                    break;

                /* Управление углом взгляда через клавиши WASD*/
                case 'W':
                    lookDX = 0.01f;
                    break;
                case 'S':
                    lookDX = -0.01f;
                    break;
                case 'A':
                    lookDY = 0.01f;
                    break;
                case 'D':
                    lookDY = -0.01f;
                    break;

                /* Управление углом обзора через клавиши стрелочек */
                case VK_LEFT:
                    lookDsY = 0.01f;
                    break;
                case VK_RIGHT:
                    lookDsY = -0.01f;
                    break;
                case VK_UP:
                    lookDsX = 0.01f;
                    break;
                case VK_DOWN:
                    lookDsX = -0.01f;
                    break;

                default:
                    break;
            }
            return 0;
        } break;

        /* Обработка отпускания клавиши */
        case WM_KEYUP: 
            /* Обнуление всех дельт для остановки изменений */
            lookDX = 0.0f;
            lookDY = 0.0f;
            lookDsX = 0.0f;
            lookDsY = 0.0f;
            break;

        /* Обработка нажатия левой кнопки */
        case WM_LBUTTONDOWN:
            mouse = true;
            /* Получение координат курсора */
            x = lParam & 0x0000FFFF; 
            y = (lParam & 0xFFFF0000) >> 16; 
            
            /* Сохранение положения курсора */
            ox = x;
            oy = y;
            break;

        /* Обработка отпускания левой кнопки */
        case WM_LBUTTONUP:
            mouse = false;
            break;

        case WM_MOUSEMOVE:
            /* Обработка только при нажатой левой кнопке */
            if (!mouse) break;
            /* Получение координат курсора */
            x = lParam & 0x0000FFFF; 
            y = (lParam & 0xFFFF0000) >> 16; 
            /* Расчёт смещения относительно прошлого положения */
            int dx = ox - x;
            int dy = y - oy;

            /* Увеличение угла поворота точки обзора в соответсвии со смещением курсора*/
            lookSwX += dy / 500.0f;
            lookSwY += dx / 500.0f;
            /* Сохранение положения курсора */
            ox = x;
            oy = y;
            break;
    }

    /* Стандартная обработка остальных сообщений */
    return DefWindowProc (hWnd, message, wParam, lParam);
}


/* Функция настроийки и инициализации Direct3D */
void initD3D(HWND hWnd) {
    d3d = Direct3DCreate9(D3D_SDK_VERSION);    // создание интерфейса D3D

    D3DPRESENT_PARAMETERS d3dpp;    // Создание структуры информции устройства

    ZeroMemory(&d3dpp, sizeof(d3dpp));    // Очистка структуры перед использованием
    d3dpp.Windowed = TRUE;    // Включение оконного режима
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;    // Включение отбрасывания старых кадров
    d3dpp.hDeviceWindow = hWnd;    // Установка окна которое будет использовано для Direct3D
    /* Настройка формата вторичного буфера */
    d3dpp.BackBufferFormat = D3DFMT_X8R8G8B8;
    d3dpp.BackBufferWidth = SCREEN_WIDTH;
    d3dpp.BackBufferHeight = SCREEN_HEIGHT;

    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    // Создать класс устройства используя информацию из структуры d3dpp
    d3d->CreateDevice(D3DADAPTER_DEFAULT,
                      D3DDEVTYPE_HAL,
                      hWnd,
                      D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                      &d3dpp,
                      &d3ddev);

    init_graphics();
    d3ddev->SetRenderState(D3DRS_ZENABLE, TRUE);    // Включения буфера глубины
    d3ddev->SetRenderState(D3DRS_LIGHTING, TRUE);    // Включение 3D освещения
    d3ddev->SetRenderState(D3DRS_AMBIENT, D3DCOLOR_XRGB(50, 50, 50));    // Окружающий свет
    init_light();

    /* Включение и настройка смешивания цветов для реализации прозрачности через альфа-канал */
    d3ddev->SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE);
    d3ddev->SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
    d3ddev->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
    d3ddev->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

    /* Создание моделей */
    sky = CreateMappedSphere(d3ddev, 80.0f, 32, 32);
    titan = CreateMappedSphere(d3ddev, 0.3f, 32, 32);
    saturn = CreateMappedSphere(d3ddev, 1.0f, 32, 32);
}

void init_light(void) {
    D3DLIGHT9 light;    // Создание структуы освещения
    D3DMATERIAL9 material;    // Создание структуры материала

    ZeroMemory(&light, sizeof(light));    // Очистка структуры освещения
    light.Type = D3DLIGHT_DIRECTIONAL;    // Установка освщения типа 'направленный свет'
    light.Diffuse = D3DXCOLOR(0.5f, 0.5f, 0.5f, 1.0f);    // Установка цвета света
    light.Direction = D3DXVECTOR3(-1.0f, -0.3f, -1.0f);   // Установка направления света

    d3ddev->SetLight(0, &light);    // Установка настроек освещения для источника света #0
    d3ddev->LightEnable(0, TRUE);    // Включение источника света #0

    ZeroMemory(&material, sizeof(D3DMATERIAL9));    // Очистка структуры материала
    material.Diffuse = D3DXCOLOR(1.0f, 1.0f, 1.0f, 1.0f);    // Установка цвета рассеяния
    material.Ambient = D3DXCOLOR(1.0f, 1.0f, 1.0f, 1.0f);    // Установка цвета окружения

    d3ddev->SetMaterial(&material);    // Применение настроек материала
}

void init_graphics(void)
{
    // Создание буфера вершин
    d3ddev->CreateVertexBuffer(4*sizeof(CUSTOMVERTEX),
                               0,
                               CUSTOMFVF,
                               D3DPOOL_MANAGED,
                               &v_buffer,
                               NULL);

    // Создание массива вершин формата CUSTOMVERTEX для модели плоскости колец
    CUSTOMVERTEX vertices[] = {
        { -3.0f, 3.0f, 0.0f,  0.0f, 0.0f, -1.0f, 0.0f, 0.0f, },
        { 3.0f, 3.0f, 0.0f,   0.0f, 0.0f, -1.0f, 0.0f, 1.0f, },
        { -3.0f, -3.0f, 0.0f, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, },
        { 3.0f, -3.0f, 0.0f,  0.0f, 0.0f, -1.0f, 1.0f, 1.0f, },
    }; 

    VOID* pVoid;    // Нулевой указатель
    // Блокировка вершенного буфера и загрузка в него вершин
    v_buffer->Lock(0, 0, (void**)&pVoid, 0);
    memcpy(pVoid, vertices, sizeof(vertices));
    // Разблокировка вершенного буфера
    v_buffer->Unlock();

    // Загрузка текстур
    D3DXCreateTextureFromFile(d3ddev, "./saturn.jpg", &saturnTexture);
    D3DXCreateTextureFromFile(d3ddev, "./titan.jpg", &titanTexture);
    D3DXCreateTextureFromFile(d3ddev, "./rings1.png", &ringsTexture);
    D3DXCreateTextureFromFile(d3ddev, "./skys.jpg", &skyTexture);

    // Отключение режима отсечения граней
    d3ddev->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
}

void setTexture(LPDIRECT3DTEXTURE9 texture) {
    d3ddev->SetTexture(0, texture);
    d3ddev->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    d3ddev->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
}

void drawRing() {
    // Построение матрицы поворота по оси X
    D3DXMatrixRotationX(&matRotateX, D3DX_PI/2-0.01);
    /* Применение полученной матрицы */
    d3ddev->SetTransform(D3DTS_WORLD, &matRotateX);
    // Выбор буфера вершин для отображения
    d3ddev->SetStreamSource(0, v_buffer, 0, sizeof(CUSTOMVERTEX));

    setTexture(ringsTexture);
    // Копирование буфера вершин во вторичный буфер
    d3ddev->DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);
}

void drawSky() {
    // Построение матрицы переноса в начало координат
    D3DXMatrixTranslation(&matTranslate, 0.0f, 0.0f, 0.0f);
    /* Применение полученной матрицы */
    d3ddev->SetTransform(D3DTS_WORLD, &matTranslate);

    setTexture(skyTexture);
    sky->DrawSubset(0);
}


void drawTitan() {
    // Построение матрицы переноса на 4 единицы по оси X
    D3DXMatrixTranslation(&matTranslate, 4.0f, 0.0f, 0.0f);
    // Построение матрицы поворота основанное на текущем значении поворота
    D3DXMatrixRotationY(&matRotateX, rotation * 1.4f);

    /* Перемножение матриц */
    D3DXMATRIX xy = matRotateY * matTranslate * matRotateX;
    /* Применение полученной матрицы */
    d3ddev->SetTransform(D3DTS_WORLD, &xy);

    /* Выбор и настройка текстуры */ 
    setTexture(titanTexture);
    /* Отображение */
    titan->DrawSubset(0);
}

void drawSaturn() {
    // Построение матрицы поворота основанное на текущем значении поворота
    D3DXMatrixRotationY(&matRotateY, rotation);
    /* Применение полученной матрицы */
    d3ddev->SetTransform(D3DTS_WORLD, &matRotateY);

    /* Выбор и настройка текстуры */
    setTexture(saturnTexture);

    /* Отображение сферы */
    saturn->DrawSubset(0);
}

void viewTransform() {
    D3DXMATRIX matView;    // Матрица транформации представления
    D3DXVECTOR3 camPos = D3DXVECTOR3 (0.0f, 0.0f, 10.0f); // Позиция камеры
    D3DXVECTOR3 lookAt = D3DXVECTOR3 (0.0f, 0.0f, 0.0f);  // Точка направления взгляда
    D3DXVECTOR3 upDir = D3DXVECTOR3 (0.0f, 1.0f, 0.0f);   // Направление "вверх"
    D3DXMatrixLookAtLH(&matView, &camPos, &lookAt, &upDir);

    /* Поворот взгляда и точки обзора */
    D3DXMatrixRotationX(&matRotateX, lookRotX);
    D3DXMatrixRotationY(&matRotateY, lookRotY);
    matView = matView * matRotateX * matRotateY;
    D3DXMatrixRotationX(&matRotateX, lookSwX);
    D3DXMatrixRotationY(&matRotateY, lookSwY);
    matView = matRotateX * matRotateY * matView;

    d3ddev->SetTransform(D3DTS_VIEW, &matView);    // Применение матрицы трансформации представления

    D3DXMATRIX matProjection;     // Матрица трансформации проекции
    D3DXMatrixPerspectiveFovLH(&matProjection,
                   D3DXToRadian(45),    // Угол поля обзора
                   // Соотношение сторон экрана
                   (FLOAT)SCREEN_WIDTH / (FLOAT)SCREEN_HEIGHT,
                   1.0f,       // Ближняя плоскость отсечения
                   100.0f);    // Дальняя плоскость отсечения 

    d3ddev->SetTransform(D3DTS_PROJECTION, &matProjection);    // Применение трансформации проекции
}

/* Функция отображения одного кадра */
void render_frame(void) {
    /* Очистка экрана и буфера глубины */
    d3ddev->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);
    d3ddev->Clear(0, NULL, D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);

    d3ddev->BeginScene();    // Начало 3D сцены

    // Выбор формата вершин
    d3ddev->SetFVF(CUSTOMFVF);
    
    rotation += 0.02f;  // Увеличение угла поворота
    lookRotX += lookDX; // Увеличение угла взгляда по Х
    lookRotY += lookDY; // Увеличение угла взгляда по Y
    lookSwX += lookDsX; // Увеличение угла поворота точки обзора по оси X
    lookSwY += lookDsY; // Увеличение угла поворота точки обзора по оси Y

    viewTransform();   // Трансформация матрицы представления и проекции

    /* Отображение объектов */
    drawSky();
    drawSaturn();
    drawTitan(); 
    drawRing();

    d3ddev->EndScene();    // Окончание 3D сцены 
    d3ddev->Present(NULL, NULL, NULL, NULL);   // Отображение созданного кадра на экране
}


/* Функция освобождения ресурсов Direct3D и COM */
void cleanD3D(void) {
    v_buffer->Release();    // Закрытие и освобождение вершенного буфера
    d3ddev->Release();    // Закрыть 3D устройство
    d3d->Release();    // Закрыть Direct3D
}

LPD3DXMESH CreateMappedSphere(LPDIRECT3DDEVICE9 pDev,float fRad,UINT slices,UINT stacks) {
    // Создание модели сферы
    LPD3DXMESH mesh;
    if (FAILED(D3DXCreateSphere(pDev,fRad,slices,stacks,&mesh,NULL))) return NULL;
    // Создание копии модели с текстурными координатами, поскольку изначально их нет.
    LPD3DXMESH texMesh;
    if (FAILED(mesh->CloneMeshFVF(D3DXMESH_SYSTEMMEM,FVF_VERTEX,pDev,&texMesh))) return mesh;
    // Изначальная модель не нужна - освобождаем
    mesh->Release();

    // Блокировка буфера вершин
    LPVERTEX pVerts;
    if (SUCCEEDED(texMesh->LockVertexBuffer(0,(void **) &pVerts))) {

        // Получение количества вершин
        int numVerts=texMesh->GetNumVertices();

        // Цикл по всем вершинам
        for (int i=0;i<numVerts;i++) {
            // Расчёт текстурных координат
            pVerts->tu=asinf(pVerts->norm.x)/D3DX_PI+0.5f;
            pVerts->tv=asinf(pVerts->norm.y)/D3DX_PI+0.5f;
            // Переход к следующей вершине
            pVerts++;
        }
        // Разблокирока буфера вершин
        texMesh->UnlockVertexBuffer();
    }
    // Возврат указателя на результат
    return texMesh;
}

