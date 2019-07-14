#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QProcess>

// from: http://askubuntu.com/questions/288494/run-system-commands-from-qml-app

class Launcher : public QObject
{
    Q_OBJECT
public:
    explicit Launcher(QObject *parent = nullptr);
    Q_INVOKABLE void launch(const QString &program, const QStringList &args);

Q_SIGNALS:
    void finished(QString result);
    void failed();

private slots:
    void processFinished(int, QProcess::ExitStatus);
    void processErrorOccurred(QProcess::ProcessError);

private:
    QProcess m_process;
};

#endif // LAUNCHER_H

