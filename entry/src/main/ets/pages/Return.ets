import router from '@ohos.router';
import { DataController } from '../Data';

@Entry
@Component
struct Return {
  private bookId: string = '';
  private recordId: string = '';

  private returnBook() {
    let data = AppStorage.Get<DataController>('data');
    let record = data.getRecord(this.recordId);

    if (record == undefined) {
      AlertDialog.show(
        {
          title: '错误',
          message: '借书编号不存在！请检查后重试。'
        }
      );
      return;
    }

    if (record.bookId != this.bookId) {
      AlertDialog.show(
        {
          title: '错误',
          message: '借书记录中的图书编号与输入的不符！请检查后重试。'
        }
      );
      return;
    }

    if (record.hasReturned) {
      AlertDialog.show(
        {
          title: '错误',
          message: '已经还过的书不能再次归还！'
        }
      );
      return;
    }

    let reader = data.getReader(record.readerId);
    let book = data.getBook(record.bookId);

    let msg: string =
      '查询到信息如下：' + '\n' +
      '读者姓名：' + reader.name + '\n' +
      '图书名：' + book.name + '\n' +
      '确认还书？';

    AlertDialog.show(
      {
        title: '还书',
        message: msg,
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '确认',
          action: () => this.doReturn()
        },
      }
    );

  }

  private doReturn() {
    let data = AppStorage.Get<DataController>('data');
    let record = data.getRecord(this.recordId);

    let curDate = new Date();
    let time = (curDate.getTime() - record.borrowDate.getTime()) / 1000;
    if (time > data.maxBorrowTime) {
      AlertDialog.show(
        {
          title: '超时',
          message: '您的借书时间超时了，请支付罚款 1 元',
          confirm: {
            value: '支付',
            action: () => {
              record.hasReturned = true;
              AlertDialog.show({ title: '成功', message: '还书成功！' });
            }
          }
        }
      )
    } else {
      record.hasReturned = true;
      AlertDialog.show({ title: '成功', message: '还书成功！' });
    }

  }

  build() {
    Column() {
      Text('还书')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin(10)
      Column({ space: 10 }) {
        Row() {
          Text('借书编号').fontSize(16).width('30%')
          TextInput({ text: this.recordId }).width('70%').onChange(val => this.recordId = val)
        }

        Row() {
          Text('图书编号').fontSize(16).width('30%')
          TextInput({ text: this.bookId }).width('70%').onChange(val => this.bookId = val)
        }
      }.width('70%')

      Row({ space: 5 }) {
        Button(' 返回 ')
          .onClick(() => router.back())
        Button(' 查询 ')
          .onClick(() => this.returnBook())
      }.margin(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}