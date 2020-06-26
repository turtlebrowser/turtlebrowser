#include "ApplicationState.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <qtwebengineglobal.h>

int main(int argc, char * argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
  QApplication app(argc, argv);

  QtWebEngine::initialize();

  turtle_browser::ApplicationState applicationState;

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("licenseModelWebView", applicationState.licenseState().searchModelWebLicenses());
  engine.rootContext()->setContextProperty("licenseModelToolkit", applicationState.licenseState().searchModelToolkitLicenses());
  engine.rootContext()->setContextProperty("licenseModelPlatform", applicationState.licenseState().searchModelPlatformLicenses());
  engine.rootContext()->setContextProperty("licenseModelAll", applicationState.licenseState().searchModelAllLicenses());
  engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
  QMetaObject::invokeMethod(engine.rootObjects().first(), "start");

  return app.exec();
}
