library user_email_comp;

import 'package:pritunl/bases/modal_content/modal_content.dart' as
  modal_content;
import 'package:pritunl/models/user.dart' as usr;
import 'package:pritunl/alert.dart' as alrt;
import 'package:pritunl/logger.dart' as logger;

import 'package:angular/angular.dart' show Component, NgOneWay;
import 'dart:async' as async;

@Component(
  selector: 'user-email',
  templateUrl: 'packages/pritunl/components/user_email/user_email.html',
  cssUrl: 'packages/pritunl/components/user_email/user_email.css'
)
class UserEmailComp extends modal_content.ModalContent {
  String okText = 'Send';
  String noCancel;
  Map<usr.User, String> userClass = {};

  @NgOneWay('users')
  Set<usr.User> users;

  async.Future submit(async.Future closeHandler()) {
    return async.Future.wait(this.users.map((user) {
      if (user.email == null) {
        return new async.Future.sync(() {
          this.userClass[user] = 'warning-text';
        });
      }

      return user.mailKey().then((_) {
        this.userClass[user] = 'success-text';
      }).catchError((err) {
        this.userClass[user] = 'danger-text';
        return new async.Future.error(err);
      });
    })).then((_) {
      this.noCancel = 'no-cancel';
      this.okText = 'Close';
      this.setAlert('Successfully emailed users.', 'success');
    }).catchError((err) {
      logger.severe('Failed to email users', err);
      this.setAlert('Failed to email users, server error occurred.',
        'danger');
    });
  }
}
